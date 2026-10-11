document.addEventListener('DOMContentLoaded', function () {
  var sources = {};
  document.querySelectorAll('.filter-option-source').forEach(function (source) {
    sources[source.dataset.field] = Array.from(source.options).map(function (option) {
      return { text: option.text, value: option.value };
    });
  });
  document.querySelectorAll('.condition-row').forEach(function (row) {
    var field = row.querySelector('[name="filterField"]');
    var value = row.querySelector('[name="filterValue"]');
    function updateOptions(keepSelection) {
      var selected = keepSelection ? value.value : '';
      while (value.options.length) value.remove(0);
      value.add(new Option('不限', ''));
      (sources[field.value] || []).forEach(function (option) {
        value.add(new Option(option.text, option.value));
      });
      if (keepSelection) {
        value.value = selected;
        if (value.selectedIndex < 0) value.selectedIndex = 0;
      }
    }
    field.addEventListener('change', function () { updateOptions(false); });
    updateOptions(true);
  });
  var fields = document.getElementById('fields');
  if (!fields) return;
  var saved = JSON.parse(localStorage.getItem('cropColumns') || '{}');
  function apply(name, visible) {
    document.querySelectorAll('[data-col="' + name + '"]').forEach(function (element) {
      if (element.tagName !== 'INPUT') element.hidden = !visible;
    });
  }
  fields.querySelectorAll('input[data-col]').forEach(function (input) {
    if (Object.prototype.hasOwnProperty.call(saved, input.dataset.col)) input.checked = saved[input.dataset.col];
    apply(input.dataset.col, input.checked);
    input.addEventListener('change', function () {
      saved[input.dataset.col] = input.checked;
      localStorage.setItem('cropColumns', JSON.stringify(saved));
      apply(input.dataset.col, input.checked);
    });
  });
});
