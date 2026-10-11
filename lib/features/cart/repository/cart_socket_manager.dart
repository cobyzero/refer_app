import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../../core/token_manager.dart';
import '../../../core/constants.dart';
import '../../../core/utils/app_log.dart';
import '../model/cart_item.dart';

class CartSocketManager {
  final TokenManager tokenManager;
  io.Socket? socket;
  Function(CartUpdateResponse)? onCartUpdated;
  bool _connecting = false;

  CartSocketManager({required this.tokenManager});

  bool get isConnected => socket?.connected ?? false;

  Future<void> connect() async {
    // Idempotente: si ya hay conexión (o una en curso), no duplicar sockets.
    if (isConnected || _connecting) return;
    _connecting = true;
    try {
      final token = await tokenManager.getAccessToken();
      // Sin token (p. ej. antes del primer login): no conectar todavía.
      // El login posterior llamará a reconnect()/connect() de nuevo.
      if (token == null) return;
      if (isConnected) return;

      // Desechar socket viejo (desconectado o con token anterior).
      socket?.dispose();
      socket = null;

      socket = io.io(
        AppConstants.socketUrl,
        io.OptionBuilder()
            .setTransports(['websocket'])
            .setAuth({'token': token})
            .enableAutoConnect()
            .build(),
      );

      socket?.onConnect((_) {
        AppLog.d('Connected to /cart namespace');
        // Auto-recuperación: cada (re)conexión pide el carrito para que
        // el badge y la lista se llenen aunque el socket se haya
        // conectado después (p. ej. justo tras el login).
        getCart();
      });

      socket?.on('cartUpdated', (data) {
        if (onCartUpdated != null) {
          onCartUpdated!(CartUpdateResponse.fromJson(data));
        }
      });

      socket?.onDisconnect((_) => AppLog.d('Disconnected from /cart namespace'));
      // Sin $err: el detalle del socket puede incluir el token de auth.
      socket?.onError((_) => AppLog.d('Socket error on /cart namespace'));
    } finally {
      _connecting = false;
    }
  }

  /// Reconecta con el token actual. Usar tras login/logout para
  /// descartar el socket viejo (o el intento sin token del arranque).
  Future<void> reconnect() async {
    disconnect();
    await connect();
  }

  void addToCart({
    required String productId,
    required String? sizeId,
    required String? typeId,
    required List<String> enhancementIds,
    required int quantity,
  }) {
    socket?.emit('addToCart', {
      'productId': productId,
      'sizeId': sizeId,
      'typeId': typeId,
      'enhancementIds': enhancementIds,
      'quantity': quantity,
    });
  }

  void removeItem(String cartItemId) {
    socket?.emit('removeItem', cartItemId);
  }

  void updateQuantity(String cartItemId, int quantity) {
    socket?.emit('updateQuantity', {
      'itemId': cartItemId,
      'quantity': quantity,
    });
  }

  void clearCart() {
    socket?.emit('clearCart');
  }

  void getCart() {
    socket?.emit('getCart');
  }

  void disconnect() {
    socket?.disconnect();
    socket = null;
  }
}
