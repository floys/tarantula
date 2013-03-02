/**
* @class Ext.form.ComboBoxMulti
* @extends Ext.form.ComboBox
* Adds freeform multiselect and duplicate entry prevention to the standard combobox
* @constructor
* Create a new ComboBoxMulti.
* @param {Object} config Configuration options
*/
Ext.form.ComboBoxMulti = function(config){
/**
* @cfg {String} sep is used to separate text entries
*/
/**
* @cfg {Boolean} preventDuplicates indicates whether repeated selections of the same option will generate extra entries
*/
Ext.apply(config);


// this option will interfere will expected operation
this.typeAhead = false;
// these options customize behavior
this.minChars = 2;
this.hideTrigger = true;
if(!this.el){
this.defaultAutoCreate = {
tag: "textarea",
style: "width:100px;height:22px;",
autocomplete: "off"

}
};
Ext.form.ComboBoxMulti.superclass.constructor.call(this, config);
if(this.grow){
this.textSizeEl = Ext.DomHelper.append(document.body, {
tag: "pre", cls: "x-form-grow-sizer"
});
//if(this.preventScrollbars){
// this.el.setStyle("overflow", "hidden");
//}
//this.el.setHeight(this.growMin);
}
};

Ext.form.ComboBoxMulti = Ext.extend(Ext.form.ComboBoxMulti, Ext.form.ComboBox, {
//Editing By Pramod Starts
/**
* @cfg {Number} growMin The minimum height to allow when grow = true (defaults to 60)
*/
growMin : 60,
/**
* @cfg {Number} growMax The maximum height to allow when grow = true (defaults to 1000)
*/
growMax: 1000,
growAppend : ' \n ',
growPad : 0,

/**
* @cfg {Boolean} preventScrollbars True to prevent scrollbars from appearing regardless of how much text is
* in the field (equivalent to setting overflow: hidden, defaults to false)
*/
preventScrollbars: false,

//editing ends by pramod


getPosition1: function(){
if (document.selection) { // IE
var r = document.selection.createRange();
var d = r.duplicate();
d.moveToElementText(this.el.dom);
d.setEndPoint('EndToEnd', r);
return d.text.length;
}
else {
return this.el.dom.selectionEnd;
}
},

getActiveRange: function(){
var s = this.sep;
var p = this.getPosition();
var v = this.getRawValue();
var left = p;
while (left > 0 && v.charAt(left) != s) {
--left;
}
if (left > 0) {
left++;
}
return {
left: left,
right: p
};
},

getActiveEntry: function(){
var r = this.getActiveRange();
return this.getRawValue().substring(r.left, r.right).replace(/^\s+|\s+$/g, '');
},

replaceActiveEntry: function(value){
var r = this.getActiveRange();
var v = this.getRawValue();
if (this.preventDuplicates && v.indexOf(value) >= 0) {
return;
}
var pad = (this.sep == ' ' ? '' : ' ');
this.setValue(v.substring(0, r.left) + (r.left > 0 ? pad : '') + value + this.sep + pad + v.substring(r.right));
var p = r.left + value.length + 2 + pad.length;
this.selectText.defer(200, this, [p, p]);
},

onSelect: function(record, index){
if (this.fireEvent('beforeselect', this, record, index) !== false) {
var value = record.data[this.valueField || this.displayField];
if (this.sep) {
this.replaceActiveEntry(value);
}
else {
this.setValue(value);
}
this.collapse();
this.fireEvent('select', this, record, index);
}
},

onDestroy : function(){
if(this.textSizeEl){
Ext.removeNode(this.textSizeEl);
}
Ext.form.ComboBoxMulti.superclass.onDestroy.call(this);
},

initQuery: function(){
this.doQuery(this.sep ? this.getActiveEntry() : this.getRawValue());
},
//Edited by Pramod
/**
* Automatically grows the field to accomodate the height of the text up to the maximum field height allowed.
* This only takes effect if grow = true, and fires the {@link #autosize} event if the height changes.
*/
autoSize : function(){
if(!this.grow || !this.textSizeEl){
return;
}
var el = this.el;
this.el.setStyle("overflow", "hidden");
var v = el.dom.value;
var ts = this.textSizeEl;
ts.innerHTML = '';
ts.appendChild(document.createTextNode(v));
v = ts.innerHTML;

Ext.fly(ts).setWidth(this.el.getWidth());
if(v.length < 1){
v = " ";
}else{
if(Ext.isIE){
v = v.replace(/\n/g, '<p> </p>');
}
v += this.growAppend;
}
ts.innerHTML = v;
var h = Math.min(this.growMax, Math.max(ts.offsetHeight, this.growMin)+this.growPad);
if(h != this.lastHeight){
this.lastHeight = h;
this.el.setHeight(h);
this.fireEvent("autosize", this, h);
}
}
});

Ext.reg('combomulti', Ext.form.ComboBoxMulti); 
