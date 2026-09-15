import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import '../../../core/theme.dart';
import '../../../core/constants.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../core/models/product_category.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_state.dart';
import '../widgets/brew_card.dart';
import '../widgets/rewards_card.dart';
import '../widgets/search_bar_home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            Semantics(
              image: true,
              label: 'Refer App logo',
              child: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.separator, width: 1),
                ),
                padding: const EdgeInsets.all(6),
                child: Image.asset('assets/images/refer_logo.png', fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.coffee_rounded, size: 18, color: AppColors.primary)),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Refer App',
              style: GoogleFonts.kaushanScript(
                fontSize: 18,
                color: AppColors.primary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              int itemCount = 0;
              if (state is CartLoaded) itemCount = state.items.length;
              return Semantics(
                button: true,
                label: 'Cart, $itemCount items',
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.text),
                      onPressed: () => context.push('/cart'),
                      tooltip: 'Cart',
                      style: IconButton.styleFrom(minimumSize: const Size(44, 44)),
                    ),
                    if (itemCount > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                          child: Text(
                            itemCount > 9 ? '9+' : itemCount.toString(),
                            style: GoogleFonts.outfit(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              String name = '';
              String? photoUrl;
              if (state is HomeLoaded) {
                name = state.user.name;
                photoUrl = state.user.photoUrl;
              }
              return Padding(
                padding: const EdgeInsets.only(right: 12, left: 4),
                child: Semantics(
                  image: true,
                  label: 'Profile photo',
                  child: UserAvatar(photoUrl: photoUrl, name: name),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) return _buildHomeShimmer(context);
          if (state is HomeError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off_rounded, size: 40, color: AppColors.textTertiary),
                    const SizedBox(height: 12),
                    Text(state.message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 16),
                    FilledButton(onPressed: () => context.read<HomeBloc>().add(HomeDataRequested()), child: const Text('Try again')),
                  ],
                ),
              ),
            );
          }
          if (state is HomeLoaded) {
            final user = state.user;
            final summary = state.summary;
            // Bottom padding accounts for GlassTabBar (~72) + SafeArea
            final bottomPadding = MediaQuery.of(context).padding.bottom + 88;

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async => context.read<HomeBloc>().add(HomeDataRequested()),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(20, 8, 20, bottomPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting — HIG Typography hierarchy
                    Semantics(
                      header: true,
                      child: Text(
                        l10n.goodMorning(user.name.split(' ')[0]),
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 28, height: 1.2),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(l10n.homeSubtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 20),
                    const SearchBarHome(),
                    const SizedBox(height: 20),
                    RewardsCard(
                      stars: summary.stars,
                      progress: summary.nextRewardProgress,
                      nextRewardMessage: l10n.starsUntilNextReward((100 - (summary.nextRewardProgress * 100)).toInt()),
                    ),
                    if (state.categories.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _CategoriesRow(categories: state.categories),
                    ],
                    const SizedBox(height: 28),
                    // Featured collections — one dynamic section per
                    // visible collection from GET /collections.
                    if (state.collections.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.separator)),
                        child: Text(l10n.noSeasonalBrews, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
                      )
                    else
                      for (final collection in state.collections) ...[
                        if (collection.products.isNotEmpty) ...[
                          _SectionHeader(title: collection.name, actionLabel: l10n.viewMenu, onAction: () => context.push('/menu')),
                          const SizedBox(height: 14),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.none,
                            child: Row(
                              children: collection.products
                                  .map((p) => Padding(
                                        padding: const EdgeInsets.only(right: 14),
                                        child: GestureDetector(
                                          onTap: () => context.push('/product/${p.id}'),
                                          child: BrewCard(
                                            title: p.name,
                                            description: p.description,
                                            price: Money.format(p.price),
                                            imageUrl: p.imageUrl,
                                            width: 220,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                          const SizedBox(height: 28),
                        ],
                      ],
                    const SizedBox(height: 28),
                    _SectionHeader(title: l10n.recentProducts, actionLabel: null, onAction: null),
                    const SizedBox(height: 14),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.latestProducts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final product = state.latestProducts[index];
                        return GestureDetector(
                          onTap: () => context.push('/product/${product.id}'),
                          child: BrewCard(
                            title: product.name,
                            description: product.description,
                            price: Money.format(product.price),
                            imageUrl: product.imageUrl,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHomeShimmer(BuildContext context) {
    final baseColor = AppColors.separator;
    final highlightColor = Colors.white;
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 180, height: 26, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8))),
            const SizedBox(height: 8),
            Container(width: 220, height: 14, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6))),
            const SizedBox(height: 20),
            Container(width: double.infinity, height: 48, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
            const SizedBox(height: 20),
            Container(width: double.infinity, height: 148, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 130, height: 18, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6))),
                Container(width: 70, height: 14, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6))),
              ],
            ),
            const SizedBox(height: 14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                children: List.generate(3, (i) => Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 220, height: 180, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
                      const SizedBox(height: 10),
                      Container(width: 120, height: 14, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6))),
                    ],
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  const _SectionHeader({required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.text, letterSpacing: -0.3)),
        ),
        if (actionLabel != null && onAction != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(minimumSize: const Size(44, 32), padding: const EdgeInsets.symmetric(horizontal: 10), tapTargetSize: MaterialTapTargetSize.padded),
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}

class _CategoriesRow extends StatelessWidget {
  final List<ProductCategory> categories;
  const _CategoriesRow({required this.categories});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(header: true, child: Text(l10n.categories, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary, letterSpacing: 0.3))),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: categories.map((c) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Semantics(
                button: true,
                label: c.description.isEmpty ? c.name : '${c.name}. ${c.description}',
                child: GestureDetector(
                  onTap: () => context.push('/search?category=${c.id}'),
                  child: _CategoryCard(category: c),
                ),
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final ProductCategory category;
  const _CategoryCard({required this.category});

  static const _width = 148.0;
  static const _height = 108.0;
  static const _radius = 18.0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_radius),
      child: SizedBox(
        width: _width,
        height: _height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: AppColors.neutralGrouped),
            if (category.imageUrl.isNotEmpty)
              CachedNetworkImage(
                imageUrl: category.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: AppColors.neutralGrouped,
                  alignment: Alignment.center,
                  child: const Icon(Icons.local_cafe_outlined, size: 26, color: AppColors.textTertiary),
                ),
                errorWidget: (_, __, ___) => const _CategoryFallbackArt(),
              )
            else
              const _CategoryFallbackArt(),
            // Legibilidad del nombre sobre la foto.
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xB3000000)],
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 10,
              child: Text(
                category.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(fontSize: 13.5, fontWeight: FontWeight.w700, color: Colors.white, height: 1.25, letterSpacing: -0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fondo con identidad cuando la categoría no tiene imagen o falla la carga.
class _CategoryFallbackArt extends StatelessWidget {
  const _CategoryFallbackArt();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: const Stack(
        children: [
          Positioned(
            right: -22,
            top: -22,
            child: _GhostCircle(diameter: 96),
          ),
          Positioned(
            left: -16,
            bottom: -28,
            child: _GhostCircle(diameter: 72),
          ),
          Center(
            child: Icon(Icons.local_cafe_outlined, size: 30, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _GhostCircle extends StatelessWidget {
  final double diameter;
  const _GhostCircle({required this.diameter});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        shape: BoxShape.circle,
      ),
    );
  }
}
