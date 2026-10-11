import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/app_log.dart';
import '../repository/cart_socket_manager.dart';
import '../model/cart_item.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartSocketManager socketManager;

  CartBloc(this.socketManager) : super(CartInitial()) {
    on<CartStarted>(_onCartStarted);
    on<CartAdded>(_onCartAdded);
    on<CartRemoved>(_onCartRemoved);
    on<CartItemQuantityUpdated>(_onCartQuantityUpdated);
    on<CartUpdatedLocally>(_onCartUpdatedLocally);
    on<CartCleared>(_onCartCleared);

    socketManager.onCartUpdated = (update) {
      add(CartUpdatedLocally(update.items, update.total));
    };
    socketManager.connect();
  }

  Future<void> _onCartStarted(
    CartStarted event,
    Emitter<CartState> emit,
  ) async {
    // No pisar un carrito ya cargado con CartLoading: cada MainNavigator
    // re-emite CartStarted y eso hacía parpadear badge y lista.
    if (state is! CartLoaded) emit(CartLoading());
    AppLog.d('Socket: Emitting getCart event...');
    if (!socketManager.isConnected) {
      // El bloc se crea al abrir la app, antes del primer login (sin token).
      // Al entrar a /main tras iniciar sesión hay que conectar aquí;
      // el onConnect del manager pide el carrito automáticamente.
      await socketManager.connect();
    } else {
      socketManager.getCart();
    }
  }

  /// Reconecta el socket con el token actual (usar tras login/logout).
  Future<void> reconnect() => socketManager.reconnect();

  void _onCartAdded(CartAdded event, Emitter<CartState> emit) {
    AppLog.d('Socket: Emitting addToCart event...');
    // Actualización optimista: el badge y la lista reaccionan al instante;
    // el servidor confirma vía `cartUpdated` y reemplaza este estado.
    final current = state;
    if (current is CartLoaded && event.productName != null) {
      final unitPrice = event.unitPrice ?? 0.0;
      final items = List<CartItem>.from(current.items);
      final existingIndex = items.indexWhere(
        (i) =>
            !i.id.startsWith('pending_') &&
            i.productId == event.productId &&
            i.size == event.sizeLabel &&
            i.type == event.typeLabel &&
            _sameEnhancements(i.enhancements, event.enhancementNames),
      );
      if (existingIndex >= 0) {
        final existing = items[existingIndex];
        final newQty = existing.quantity + event.quantity;
        items[existingIndex] = existing.copyWith(
          quantity: newQty,
          totalPrice: existing.unitPrice * newQty,
        );
      } else {
        items.add(
          CartItem(
            id: 'pending_${DateTime.now().microsecondsSinceEpoch}',
            productId: event.productId,
            name: event.productName!,
            imageUrl: event.imageUrl ?? '',
            size: event.sizeLabel,
            type: event.typeLabel,
            enhancements: List<String>.from(event.enhancementNames),
            quantity: event.quantity,
            unitPrice: unitPrice,
            totalPrice: unitPrice * event.quantity,
            starsReward: 0,
          ),
        );
      }
      emit(
        CartLoaded(items: items, total: _sumTotal(items)),
      );
    }
    socketManager.addToCart(
      productId: event.productId,
      sizeId: event.sizeId,
      typeId: event.typeId,
      enhancementIds: event.enhancementIds,
      quantity: event.quantity,
    );
  }

  void _onCartRemoved(CartRemoved event, Emitter<CartState> emit) {
    AppLog.d('Socket: Emitting removeItem event...');
    final current = state;
    if (current is CartLoaded) {
      final items = current.items.where((i) => i.id != event.cartItemId).toList();
      emit(CartLoaded(items: items, total: _sumTotal(items)));
    }
    socketManager.removeItem(event.cartItemId);
  }

  void _onCartQuantityUpdated(
    CartItemQuantityUpdated event,
    Emitter<CartState> emit,
  ) {
    AppLog.d('Socket: Emitting updateQuantity event...');
    final current = state;
    if (current is CartLoaded) {
      if (event.newQuantity <= 0) {
        final items =
            current.items.where((i) => i.id != event.cartItemId).toList();
        emit(CartLoaded(items: items, total: _sumTotal(items)));
      } else {
        final items = current.items
            .map(
              (i) => i.id == event.cartItemId
                  ? i.copyWith(
                      quantity: event.newQuantity,
                      totalPrice: i.unitPrice * event.newQuantity,
                    )
                  : i,
            )
            .toList();
        emit(CartLoaded(items: items, total: _sumTotal(items)));
      }
    }
    socketManager.updateQuantity(event.cartItemId, event.newQuantity);
  }

  static double _sumTotal(List<CartItem> items) =>
      items.fold(0.0, (sum, i) => sum + i.totalPrice);

  static bool _sameEnhancements(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    final sortedA = List<String>.from(a)..sort();
    final sortedB = List<String>.from(b)..sort();
    for (var i = 0; i < sortedA.length; i++) {
      if (sortedA[i] != sortedB[i]) return false;
    }
    return true;
  }

  void _onCartUpdatedLocally(
    CartUpdatedLocally event,
    Emitter<CartState> emit,
  ) {
    AppLog.d('Socket: Cart updated with ${event.items.length} items');
    emit(CartLoaded(items: event.items.cast<CartItem>(), total: event.total));
  }

  void _onCartCleared(CartCleared event, Emitter<CartState> emit) {
    socketManager.clearCart();
    emit(CartLoaded(items: [], total: 0.0));
  }

  @override
  Future<void> close() {
    socketManager.disconnect();
    return super.close();
  }
}
