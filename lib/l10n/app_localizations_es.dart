// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get welcomeBack => 'Bienvenido de nuevo.';

  @override
  String get home => 'Inicio';

  @override
  String get welcomeSubtitle =>
      'Tus referidos y recompensas están a solo un inicio de sesión.';

  @override
  String get email => 'Correo electrónico';

  @override
  String get emailHint => 'nombre@correo.com';

  @override
  String get password => 'Contraseña';

  @override
  String get passwordHint => '........';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get signIn => 'Iniciar Sesión';

  @override
  String get orContinueWith => 'O CONTINUAR CON';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get dontHaveAccount => '¿No tienes una cuenta?';

  @override
  String get signUp => 'Regístrate';

  @override
  String get settings => 'Ajustes';

  @override
  String get account => 'CUENTA';

  @override
  String get personalInfo => 'Información Personal';

  @override
  String get paymentMethods => 'Métodos de Pago';

  @override
  String get preferences => 'PREFERENCIAS';

  @override
  String get orderHistory => 'Historial de Pedidos';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get language => 'Idioma';

  @override
  String get security => 'SEGURIDAD';

  @override
  String get changePassword => 'Cambiar Contraseña';

  @override
  String get biometricLogin => 'Inicio Biométrico';

  @override
  String get supportLegal => 'SOPORTE Y LEGAL';

  @override
  String get helpCenter => 'Centro de Ayuda';

  @override
  String get termsOfService => 'Términos de Servicio';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get signOut => 'Cerrar Sesión';

  @override
  String get version => 'Versión';

  @override
  String get viewProfile => 'Ver Perfil';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get signupSubtitle => 'Crea tu cuenta y empieza a referir.';

  @override
  String get fullName => 'Nombre Completo';

  @override
  String get fullNameHint => 'Elias Thorne';

  @override
  String get confirmPassword => 'Confirmar Contraseña';

  @override
  String acceptTerms(String terms, String privacy) {
    return 'Acepto los $terms y la $privacy.';
  }

  @override
  String get keepUpdated =>
      'Manténganme actualizado con colecciones de temporada y noticias exclusivas del tostadero.';

  @override
  String get accountCreatedSuccess => '¡Cuenta creada exitosamente!';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta? Iniciar Sesión';

  @override
  String get createAccount => 'Crear Cuenta';

  @override
  String get appName => 'Referral App';

  @override
  String goodMorning(String name) {
    return 'Buenos días, $name';
  }

  @override
  String get homeSubtitle => 'Tu café diario está listo para ser descubierto.';

  @override
  String starsUntilNextReward(int count) {
    return '$count estrellas más para tu próximo café artesanal gratis';
  }

  @override
  String get seasonalBrews => 'Cafés de Temporada';

  @override
  String get viewMenu => 'Ver menú';

  @override
  String get noSeasonalBrews => 'No hay cafés de temporada disponibles';

  @override
  String get quickOrder => 'Pedido Rápido';

  @override
  String get categories => 'Categorías';

  @override
  String get coffee => 'Café';

  @override
  String get tea => 'Té';

  @override
  String get bakery => 'Panadería';

  @override
  String get merchandise => 'Mercancía';

  @override
  String get productDetailsTitle => 'El Sommelier Sensorial';

  @override
  String get selectSize => 'SELECCIONAR TAMAÑO';

  @override
  String get milkChoice => 'HAZ TU ELECCIÓN';

  @override
  String get enhancements => 'MEJORAS';

  @override
  String get extraEspresso => 'Shot de Espresso Extra';

  @override
  String get sweetener => 'Endulzante';

  @override
  String get addToOrder => 'Agregar al pedido';

  @override
  String get calories => 'CALORÍAS';

  @override
  String get caffeine => 'CAFEÍNA';

  @override
  String get tall => 'Tall';

  @override
  String get grande => 'Grande';

  @override
  String get venti => 'Venti';

  @override
  String get wholeMilk => 'Leche Entera';

  @override
  String get oatMilk => 'Leche de Avena';

  @override
  String get almondMilk => 'Leche de Almendras';

  @override
  String get sensoryRoastSeries => 'Serie Sensory Roast';

  @override
  String get searchHint => 'Busca café, té o delicias...';

  @override
  String get orders => 'Pedidos';

  @override
  String get stars => 'Estrellas';

  @override
  String get checkout => 'Finalizar Pedido';

  @override
  String get pickupLocation => 'Punto de Entrega';

  @override
  String get pickupTime => 'Tiempo de Entrega';

  @override
  String get yourOrder => 'Tu Pedido';

  @override
  String get paymentMethod => 'Método de Pago';

  @override
  String get orderSummary => 'Resumen del Pedido';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get serviceFee => 'Tarifa de Servicio';

  @override
  String get total => 'Total';

  @override
  String get placeOrder => 'Realizar Pedido';

  @override
  String get devPaymentTitle => 'Modo desarrollo';

  @override
  String devPaymentMessage(Object amount) {
    return 'Estás en DEV: se omitirá el pago con tarjeta y el pedido se completará directamente por $amount.';
  }

  @override
  String get devPaymentConfirm => 'Continuar sin pagar';

  @override
  String get devPaymentCancel => 'Cancelar';

  @override
  String get orderPlaced => '¡Pedido Realizado!';

  @override
  String get orderSuccessDetail =>
      'Tu café artesanal estará listo en 10-15 minutos.';

  @override
  String get backToHome => 'Volver al Inicio';

  @override
  String get selectFutureTime => 'Por favor selecciona una hora en el futuro';

  @override
  String get orderCreateError => 'No pudimos crear tu pedido. Intenta de nuevo.';

  @override
  String get orderConfirmError =>
      'Tu pago fue recibido pero no pudimos confirmar tu pedido. Contacta a soporte.';

  @override
  String get errorLoadingOrders => 'Error al cargar pedidos';

  @override
  String get noOrdersFound => 'No hay pedidos realizados';

  @override
  String get thisMonth => 'ESTE MES';

  @override
  String get yourCollection => 'TU COLECCIÓN';

  @override
  String get pastExperiences => 'Experiencias\npasadas';

  @override
  String get reorder => 'Volver a pedir';

  @override
  String get statusOrdered => 'ORDENADO';

  @override
  String get statusPreparing => 'PREPARANDO';

  @override
  String get statusReady => 'LISTO PARA RECOGER';

  @override
  String get statusCompleted => 'COMPLETADO';

  @override
  String get statusCancelled => 'CANCELADO';

  @override
  String get viewFullMonth => 'Ver todo el mes';

  @override
  String get yourRituals => 'Tus Rituales';

  @override
  String get ritualsSubtitle =>
      'Siguiendo tus antojos actuales y favoritos pasados del tostadero.';

  @override
  String get activeOrders => 'Pedidos Activos';

  @override
  String activeCount(int count) {
    return '$count activos';
  }

  @override
  String get noHistoryYet => 'Aún no hay historial';

  @override
  String get viewFullArchive => 'Ver archivo completo';

  @override
  String orderNumber(String number) {
    return 'Pedido #$number';
  }

  @override
  String get statusBrewing => 'INFUSIONANDO';

  @override
  String get estimatedPickup => 'Recogida estimada';

  @override
  String get estimatedPickupDetail =>
      'Aproximadamente 6-8 minutos en el tostadero de la 5ta Ave.';

  @override
  String get viewDirections => 'Ver Direcciones';

  @override
  String get reorderAll => 'Volver a pedir todo';

  @override
  String get currentBalance => 'SALDO ACTUAL';

  @override
  String get starsRewards => 'Recompensas de Estrellas';

  @override
  String get redeemYourStars => 'Canjea tus Estrellas';

  @override
  String get earningPerks => 'Ganancias y Beneficios';

  @override
  String starsRemaining(int count, String reward) {
    return '$count estrellas más para tu $reward';
  }

  @override
  String get recentProducts => 'Productos Recientes';

  @override
  String get insufficientStars =>
      'No tienes suficientes estrellas para esta recompensa.';

  @override
  String get redeemReward => 'Canjear Recompensa';

  @override
  String confirmRedemption(int stars) {
    return '¿Estás seguro de que quieres gastar $stars estrellas en esta recompensa?';
  }

  @override
  String get confirm => 'Confirmar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get currentPassword => 'Contraseña Actual';

  @override
  String get currentPasswordHint => 'Ingresa tu contraseña actual';

  @override
  String get newPassword => 'Nueva Contraseña';

  @override
  String get newPasswordHint => 'Ingresa tu nueva contraseña (min. 6 car.)';

  @override
  String get passwordChangedSuccessfully =>
      '¡Contraseña cambiada exitosamente!';

  @override
  String get errorChangingPassword =>
      'Error al cambiar la contraseña. Por favor verifica tus datos.';

  @override
  String get go_to_checkout => 'Ir al pago';

  @override
  String get reviewSelection => 'Revisar selección';

  @override
  String itemsCount(int count) {
    return '$count productos';
  }

  @override
  String get promoCode => 'CÓDIGO PROMOCIONAL';

  @override
  String get enterCode => 'Ingresar código';

  @override
  String get apply => 'Aplicar';

  @override
  String get estimatedTax => 'Impuesto estimado';

  @override
  String get cartEmpty => 'Tu carrito está vacío';

  @override
  String get cartInfoMessage =>
      'Los productos se preparan frescos a tu llegada. Disfruta de nuestra experiencia sensorial en su punto máximo llegando dentro de los 10 minutos de tu hora de recogida.';

  @override
  String rewardClaim(String title) {
    return 'Reclamar recompensa: $title';
  }

  @override
  String get claimReward => 'Reclamar recompensa';

  @override
  String earningStars(int stars) {
    return '¡Estás ganando $stars estrellas con este pedido!';
  }

  @override
  String get orderStatusTitle => 'Estado del Pedido';

  @override
  String get orderIsReady => '¡Tu pedido está listo!';

  @override
  String get pickupInstructions =>
      'Pasa directamente a la barra de entregas para recoger tu orden. ¡Que lo disfrutes!';

  @override
  String get editProfile => 'Editar Perfil';

  @override
  String get saveChanges => 'Guardar Cambios';

  @override
  String get emailAddress => 'Correo Electrónico';

  @override
  String get phoneNumber => 'Número de Teléfono';

  @override
  String get birthDate => 'Fecha de Nacimiento';

  @override
  String get tapToUpdateImage => 'Toca para actualizar imagen';

  @override
  String get profileUpdated => 'Perfil actualizado';

  @override
  String get errorUpdatingProfile => 'Error al actualizar';

  @override
  String get orderDetails => 'Detalles del Pedido';

  @override
  String get orderDate => 'Fecha';

  @override
  String get searchFAQ => 'Buscar preguntas frecuentes...';

  @override
  String get faqCategoryGeneral => 'General';

  @override
  String get faqCategoryPayments => 'Pagos';

  @override
  String get faqCategoryOrders => 'Pedidos';

  @override
  String get faqCategoryAccount => 'Cuenta';

  @override
  String get contactSupport => 'Contactar Soporte';

  @override
  String get contactUsEmail => 'Escríbenos';

  @override
  String get contactUsPhone => 'Llámanos';

  @override
  String get faqQ1 => '¿Cómo gano estrellas?';

  @override
  String get faqA1 =>
      'Ganas estrellas con cada compra. Por cada dólar gastado, obtienes 1 estrella. ¡Canjea tus estrellas por bebidas gratis y recompensas!';

  @override
  String get faqQ2 => '¿Cómo recojo mi pedido?';

  @override
  String get faqA2 =>
      'Una vez realizado tu pedido, puedes ver su estado en la pestaña de Pedidos. Cuando aparezca como LISTO, dirígete al mostrador y muestra tu número de orden.';

  @override
  String get faqQ3 => '¿Qué métodos de pago aceptan?';

  @override
  String get faqA3 =>
      'Aceptamos tarjetas de crédito y débito principales, Apple Pay y pagos con billeteras digitales directamente en la vista de pago.';

  @override
  String get faqQ4 => '¿Cómo cambio mi contraseña?';

  @override
  String get faqA4 =>
      'Ve a ajustes y, bajo la sección de Seguridad, toca en Cambiar Contraseña. Ingresa tu contraseña actual y la nueva para actualizarla.';

  @override
  String get noResults => 'No se encontraron resultados';

  @override
  String get all => 'Todo';

  @override
  String get searchSubtitle => 'Selecciones exclusivas para cada paladar.';

  @override
  String noProductsFound(String query) {
    return 'No se encontraron productos para \"$query\"';
  }

  @override
  String get failedToLoadCategories => 'Error al cargar las categorías';

  @override
  String get noCategoriesFound => 'No se encontraron categorías';

  @override
  String get explore => 'EXPLORAR';

  @override
  String get discoverPremiumSelection => 'Descubre nuestra selección premium';

  @override
  String get unclaimedRewards => 'Tus recompensas sin reclamar';

  @override
  String get tapToClaim => 'Toca para reclamar';

  @override
  String get stayTunedPerks => '¡Mantente atento para próximas ventajas!';

  @override
  String get viewHistory => 'Ver Historial';

  @override
  String redeemingReward(String title) {
    return 'Canjeando $title...';
  }

  @override
  String get recentActivity => 'Actividad Reciente';

  @override
  String get noRecentActivity => 'Sin actividad reciente';

  @override
  String get starsHistory => 'Historial de Estrellas';

  @override
  String get change => 'Cambiar';

  @override
  String get selectPickupPoint => 'Seleccionar Punto de Entrega';

  @override
  String get asap => 'Lo antes posible';

  @override
  String get scheduleLater => 'Programar para después';

  @override
  String get selectSpecificTime => 'Seleccionar hora específica';

  @override
  String get stripePayment => 'Tarjeta';

  @override
  String get safeSecure => 'Seguro y Confiable';

  @override
  String get underMaintenance => 'En Mantenimiento';

  @override
  String get maintenanceDescription =>
      'Actualmente estamos actualizando nuestros sistemas de tostado para servirle mejor. Volveremos pronto.';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get estimatedTime => 'Tiempo estimado: ~30 mins';

  @override
  String get pleaseAcceptTerms =>
      'Por favor acepta los Términos y la Política de Privacidad';

  @override
  String get recoveryCodeSent => 'Código de recuperación enviado correctamente';

  @override
  String get passwordResetSuccess =>
      'Contraseña restablecida. Por favor inicia sesión.';

  @override
  String productAddedToCart(String product) {
    return '¡$product agregado al carrito!';
  }

  @override
  String get enterValidEmail => 'Ingresa un correo válido';

  @override
  String get enterPassword => 'Ingresa tu contraseña';

  @override
  String get enterFullName => 'Ingresa tu nombre completo';

  @override
  String get passwordMinLength =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get enter6DigitCode => 'Ingresa el código de 6 dígitos';

  @override
  String get requiredField => 'Campo requerido';

  @override
  String get min6Chars => 'Mín. 6 caracteres';

  @override
  String get minimum6Chars => 'Mínimo 6 caracteres';

  @override
  String get repeatPassword => 'Repetir contraseña';

  @override
  String get verificationCode => 'Código de verificación';

  @override
  String get enter6DigitCodeHint => 'Ingresa el código de 6 dígitos';

  @override
  String get recoverPassword => 'Recuperar contraseña';

  @override
  String get recoverPasswordSubtitle =>
      'Ingresa tu correo electrónico para recibir un código de verificación de 6 dígitos y restablecer tu contraseña.';

  @override
  String resetPasswordSubtitle(String email) {
    return 'Ingresa el código de recuperación de 6 dígitos enviado a $email y elige tu nueva contraseña.';
  }

  @override
  String get sendCode => 'Enviar código';

  @override
  String get resetPassword => 'Restablecer contraseña';

  @override
  String agreeTermsPrivacy(String terms, String privacy) {
    return 'Al iniciar sesión aceptas nuestros $terms y $privacy.';
  }

  @override
  String get back => 'Atrás';

  @override
  String get updateRequiredTitle => 'Actualización requerida';

  @override
  String updateRequiredMessage(String version) {
    return 'Esta versión ya no es compatible. Actualiza a la versión $version o superior para continuar.';
  }

  @override
  String currentVersion(String version) {
    return 'Versión actual: $version';
  }

  @override
  String get updateAvailableTitle => 'Actualización disponible';

  @override
  String updateAvailableMessage(String version) {
    return 'La versión $version ya está disponible con mejoras. ¿Quieres actualizar ahora?';
  }

  @override
  String get updateNow => 'Actualizar ahora';

  @override
  String get remindLater => 'Más tarde';

  @override
  String get couldNotOpenStore => 'No se pudo abrir la tienda';

  @override
  String get couldNotOpenLink => 'No se pudo abrir el enlace';

  @override
  String get verifyEmailTitle => 'Verifica tu correo';

  @override
  String verifyEmailSubtitle(String email) {
    return 'Ingresa el código de 6 dígitos que enviamos a $email.';
  }

  @override
  String get verifyEmailAction => 'Verificar correo';

  @override
  String get emailVerifiedSuccess => '¡Correo verificado! Sesión iniciada.';

  @override
  String get resendCode => 'Reenviar código';

  @override
  String resendCodeCooldown(int seconds) {
    return 'Reenviar en ${seconds}s';
  }
}
