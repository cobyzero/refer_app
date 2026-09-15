import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:refer_app/core/theme.dart';
import 'package:refer_app/core/constants.dart';
import 'package:refer_app/features/cart/bloc/locations_state.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import 'package:refer_app/core/services/stripe_service.dart';
import 'package:refer_app/core/widgets/app_snackbar.dart';
import 'package:refer_app/core/di.dart';
import 'package:refer_app/features/orders/repository/orders_repository.dart';
import '../bloc/cart_bloc.dart'; import '../bloc/cart_state.dart'; import '../bloc/cart_event.dart';
import '../bloc/locations_bloc.dart'; import '../bloc/pickup_time_bloc.dart';
import 'widgets/checkout_section_header.dart'; import 'widgets/pickup_location_card.dart'; import 'widgets/pickup_time_selector.dart'; import 'widgets/checkout_cart_items_list.dart'; import 'widgets/payment_method_card.dart'; import 'widgets/order_summary_card.dart';

class CheckoutScreen extends StatefulWidget {
  final String? redeemedRewardId; final String? redeemedRewardTitle; final String? redeemedRewardImage;
  const CheckoutScreen({super.key, this.redeemedRewardId, this.redeemedRewardTitle, this.redeemedRewardImage});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  /// Guards the multi-step flow (create -> pay -> confirm) against double taps.
  bool _placing = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, surfaceTintColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, color: AppColors.text), onPressed: () => context.pop(), style: IconButton.styleFrom(minimumSize: const Size(44,44))), title: Text(l10n.checkout, style: GoogleFonts.outfit(color: AppColors.text, fontWeight: FontWeight.w600, fontSize: 17, letterSpacing: -0.2)), centerTitle: true),
      body: BlocBuilder<CartBloc, CartState>(builder: (context, state) {
        double total = 0; int itemCount = 0; final isClaimingReward = widget.redeemedRewardId != null;
        if (!isClaimingReward && state is CartLoaded) { total = state.total; itemCount = state.items.length; }
        final serviceFee = ServiceFee.amountFor(total);
        return Stack(children: [
          SingleChildScrollView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 88), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CheckoutSectionHeader(title: l10n.pickupLocation), const SizedBox(height: 8), const PickupLocationCard(), const SizedBox(height: 20),
            CheckoutSectionHeader(title: l10n.pickupTime), const SizedBox(height: 8), const PickupTimeSelector(), const SizedBox(height: 20),
            CheckoutSectionHeader(title: l10n.yourOrder), const SizedBox(height: 8),
            if (isClaimingReward)
              Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.separator)), child: Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.6), shape: BoxShape.circle), child: const Icon(Icons.star_rounded, color: AppColors.primary, size: 18)), const SizedBox(width: 10), Expanded(child: Text(l10n.rewardClaim(widget.redeemedRewardTitle ?? ''), style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.text)))]))
            else if (state is CartLoaded) CheckoutCartItemsList(items: state.items),
            const SizedBox(height: 20),
            if (!isClaimingReward) ...[
              CheckoutSectionHeader(title: l10n.paymentMethod), const SizedBox(height: 8), const PaymentMethodCard(), const SizedBox(height: 20),
              OrderSummaryCard(total: total, itemCount: itemCount, serviceFee: serviceFee, items: state is CartLoaded ? state.items : []),
            ],
          ])),
          Align(alignment: Alignment.bottomCenter, child: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(20, 8, 20, 16), child: FilledButton(
            onPressed: _placing ? null : () => _handlePlaceOrder(context, isClaimingReward ? 0 : total, isClaimingReward ? 0 : serviceFee),
            style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              if (_placing) ...[const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)), const SizedBox(width: 8)],
              Text(isClaimingReward ? l10n.claimReward : l10n.placeOrder, style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
              if (!isClaimingReward) ...[const SizedBox(width: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(8)), child: Text(Money.format(TaxConfig.applyTo(total) + serviceFee), style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)))],
            ]),
          )))),
        ]);
      }),
    );
  }

  Future<void> _handlePlaceOrder(BuildContext context, double total, double serviceFee) async {
    if (_placing) return;
    // Order-first flow: the button amount is only an estimate; the server
    // prices the order and Stripe charges exactly that.
    final amount = double.parse((TaxConfig.applyTo(total) + serviceFee).toStringAsFixed(2));
    // En DEV se avisa y se confirma directo sin Stripe (el servidor debe
    // tener ALLOW_UNVERIFIED_PAYMENTS=true; jamás en prod).
    if (AppConstants.isDev && widget.redeemedRewardId == null) {
      final proceed = await _showDevBypassDialog(context, amount);
      if (!context.mounted || proceed != true) return;
    }
    setState(() => _placing = true);
    try {
      if (widget.redeemedRewardId != null) {
        await _claimRewardOrder(context);
      } else {
        await _placePaidOrder(context, total, serviceFee);
      }
    } finally {
      if (mounted) setState(() => _placing = false);
    }
  }

  /// Aviso de que en DEV el pago se salta y el pedido se completa directo.
  Future<bool?> _showDevBypassDialog(BuildContext context, double amount) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [
          const Icon(Icons.developer_mode_rounded, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(child: Text(l10n.devPaymentTitle, style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.text))),
        ]),
        content: Text(l10n.devPaymentMessage(Money.format(amount)), style: GoogleFonts.outfit(fontSize: 13.5, height: 1.5, color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(l10n.devPaymentCancel)),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: Text(l10n.devPaymentConfirm),
          ),
        ],
      ),
    );
  }

  /// Shared validation + payload. Totals/price are sent for telemetry only:
  /// the server reprices everything from its catalog.
  Map<String, dynamic>? _collectInputs(BuildContext context, {required double total, required double serviceFee, required double amount}) {
    final l10n = AppLocalizations.of(context)!;
    final locState = context.read<LocationsBloc>().state; final timeState = context.read<PickupTimeBloc>().state; final cartState = context.read<CartBloc>().state;
    final isClaimingReward = widget.redeemedRewardId != null; if (!isClaimingReward && cartState is! CartLoaded) return null;
    // Programar para después exige una hora futura vigente al pagar
    // (pudo pasar la hora entre elegirla y confirmar). Sin esto el pedido
    // llegaría sin pickupTime y la barra lo trataría como "para ahora".
    if (!timeState.hasValidPickupTime) {
      AppSnackBar.error(context, l10n.selectFutureTime);
      return null;
    }
    String locationId = ''; String locationName = 'Downtown Studio';
    if (locState is LocationsLoaded && locState.selectedLocation != null) { locationId = locState.selectedLocation!.id; locationName = locState.selectedLocation!.name; }
    final pickupTime = timeState.toApiPickupTime();
    final orderData = isClaimingReward ? {'locationId': locationId, 'total': 0, 'serviceFee': 0, 'paymentMethod': 'REWARD', 'pickupTime': pickupTime, 'items': [{'productId': 'reward-item', 'name': widget.redeemedRewardTitle, 'quantity': 1, 'price': 0, 'imageUrl': widget.redeemedRewardImage ?? ''}], 'redeemedRewardId': widget.redeemedRewardId } : {'locationId': locationId, 'total': amount, 'serviceFee': serviceFee, 'paymentMethod': 'STRIPE', 'pickupTime': pickupTime, 'items': (cartState as CartLoaded).items.map((i) => {'productId': i.productId, 'name': i.name, 'quantity': i.quantity, 'price': i.totalPrice, 'size': i.size, 'type': i.type, 'imageUrl': i.imageUrl, 'enhancements': i.enhancements}).toList()};
    return {'locationName': locationName, 'orderData': orderData};
  }

  void _finishOrder(BuildContext context, Map<String, dynamic> order, String locationName) {
    context.read<CartBloc>().add(CartCleared());
    final orderNumber = order['orderNumber'] as String? ?? '00000';
    context.go('/order-status?orderId=$orderNumber&locationName=$locationName&userId=');
  }

  /// Reward claims settle immediately (no money moves).
  Future<void> _claimRewardOrder(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final inputs = _collectInputs(context, total: 0, serviceFee: 0, amount: 0);
    if (inputs == null || !context.mounted) return;
    final orderResponse = await sl<OrdersRepository>().createOrder(inputs['orderData'] as Map<String, dynamic>);
    if (!context.mounted) return;
    if (orderResponse == null) {
      AppSnackBar.error(context, l10n.orderCreateError);
      return;
    }
    _finishOrder(context, orderResponse, inputs['locationName'] as String);
  }

  /// Paid flow: 1. create (server prices, PENDING) -> 2. Stripe sheet for the
  /// server total -> 3. confirm (server verifies with Stripe).
  Future<void> _placePaidOrder(BuildContext context, double total, double serviceFee) async {
    final l10n = AppLocalizations.of(context)!;
    final amount = double.parse((TaxConfig.applyTo(total) + serviceFee).toStringAsFixed(2));
    final inputs = _collectInputs(context, total: total, serviceFee: serviceFee, amount: amount);
    if (inputs == null || !context.mounted) return;
    final ordersRepo = sl<OrdersRepository>();
    // 1. Order first.
    final orderResponse = await ordersRepo.createOrder(inputs['orderData'] as Map<String, dynamic>);
    if (!context.mounted) return;
    final orderId = orderResponse?['id'] as String?;
    if (orderId == null || orderId.isEmpty) {
      AppSnackBar.error(context, l10n.orderCreateError);
      return;
    }
    final locationName = inputs['locationName'] as String;
    // 2. Dev: confirm directly without the sheet.
    if (AppConstants.isDev) {
      final confirmed = await ordersRepo.confirmOrder(orderId);
      if (!context.mounted) return;
      if (confirmed == null) {
        AppSnackBar.error(context, l10n.orderConfirmError);
        return;
      }
      _finishOrder(context, confirmed, locationName);
      return;
    }
    // 3. Sheet + confirm. payForOrder awaits onSuccess, so _placing covers
    // the whole flow.
    await sl<StripeService>().payForOrder(
      orderId: orderId,
      currency: Money.stripeCurrency,
      onSuccess: () async {
        final confirmed = await ordersRepo.confirmOrder(orderId);
        if (!context.mounted) return;
        if (confirmed == null) {
          AppSnackBar.error(context, l10n.orderConfirmError);
          return;
        }
        _finishOrder(context, confirmed, locationName);
      },
      onError: (msg) async {
        // Void the pending order so it doesn't linger; a dismissed sheet
        // is not worth an alert.
        await ordersRepo.cancelOrder(orderId);
        if (!context.mounted) return;
        if (!msg.toLowerCase().contains('cancel')) {
          AppSnackBar.error(context, msg);
        }
      },
    );
  }
}
