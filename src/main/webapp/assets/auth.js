document.addEventListener('DOMContentLoaded', function () {
  var form = document.getElementById('registerForm');
  if (!form) return;
  form.addEventListener('submit', function (event) {
    var password = form.elements.password.value;
    var confirm = form.elements.confirmPassword.value;
    var error = document.getElementById('formError');
    error.hidden = password === confirm;
    error.textContent = password === confirm ? '' : '两次密码不一致';
    if (password !== confirm) event.preventDefault();
  });
});
