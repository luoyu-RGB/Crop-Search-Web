const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');

class Select {
  constructor(value, options = []) {
    this.current = value;
    this.options = options;
    this.listeners = {};
  }
  get value() { return this.current; }
  set value(value) { this.current = this.options.some(option => option.value === value) ? value : ''; }
  get selectedIndex() { return this.options.findIndex(option => option.value === this.current); }
  set selectedIndex(index) { this.current = this.options[index].value; }
  add(option) { this.options.push(option); }
  remove(index) { this.options.splice(index, 1); }
  addEventListener(event, listener) { this.listeners[event] = listener; }
  change(value) { this.current = value; this.listeners.change(); }
}

const sourceData = [
  ['family', '松科'], ['genus', '松属'], ['distribution', '广西'], ['uses', '食用']
].map(([field, value]) => ({ dataset: { field }, options: [{ text: value, value }] }));
const rows = [
  { field: new Select('family'), value: new Select('松科', [{ text: '不限', value: '' }, { text: '松科', value: '松科' }]) },
  { field: new Select(''), value: new Select('', [{ text: '不限', value: '' }]) },
  { field: new Select(''), value: new Select('', [{ text: '不限', value: '' }]) }
].map(row => ({ ...row, querySelector(selector) { return selector.includes('filterField') ? row.field : row.value; } }));
let onReady;
const document = {
  addEventListener(event, listener) { if (event === 'DOMContentLoaded') onReady = listener; },
  querySelectorAll(selector) { return selector === '.filter-option-source' ? sourceData : rows; },
  getElementById() { return null; }
};
const script = fs.readFileSync(path.resolve(__dirname, '../../main/webapp/assets/search.js'), 'utf8');
vm.runInNewContext(script, { document, Option: function (text, value) { this.text = text; this.value = value; } });
onReady();
rows[0].field.change('genus');
rows[1].field.change('distribution');
rows[2].field.change('uses');
assert.deepEqual(rows.map(row => row.value.options.map(option => option.value)), [
  ['', '松属'], ['', '广西'], ['', '食用']
]);
rows[0].field.change('family');
assert.deepEqual(rows[0].value.options.map(option => option.value), ['', '松科']);
console.log('All three condition rows update independently.');
