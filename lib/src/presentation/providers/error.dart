class AppError {
  final String message;
  final bool hasError;

  AppError({required this.message, this.hasError = false});
}
