class W {
  static String strLogout = '';
  static String strLoginSuccess = '';

  static defaultLang() {
    en();
  }

  static en() {
    strLogout = 'Are you sure you want to leave?';
    strLoginSuccess = 'Login success';
  }

  static ch() {
    strLogout = '確定要離開嗎?';
    strLoginSuccess = '登入成功';
  }
}
