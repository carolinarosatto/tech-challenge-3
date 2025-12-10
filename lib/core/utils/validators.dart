class Validators {
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Digite seu e-mail';
    }
    if (!RegExp(r'.+@.+\..+').hasMatch(value)) {
      return 'E-mail inválido';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Digite sua senha';
    }
    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Digite seu nome';
    }
    if (value.trim().length < 3) {
      return 'Nome muito curto';
    }
    return null;
  }
}
