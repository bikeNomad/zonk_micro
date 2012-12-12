// set up app editor with a sample
// MooTools

// $() is the same as document.id() inside the closure
(function($) {

    var Zonk_TableEditor = new Class({
        Implements: Events,

        table: null,

        initialize: function(table) {
            this.table = table;
        },

        addInput: function() {
        // tbl.insertRow(-1);
        },

        addOutput: function() {
        // tbl.insertRow(-1);
        },

        addEmptyRule: function() {
        },

        addRule: function() {
        },
    });

    // return a table editor
    Zonk_Table.implement('toElement', function() {
        var tbl = new Element('table', { 'class': 'task_editor' });
        var inputTbody = new Element('tbody', { 'class': 'task_inputs' });
        var tr = new Element('tr');
        var th = new Element('th', { html: 'Inputs' })
        th.inject(tr);
        tr.inject(inputTbody);
        (new Element('div', { styles: { height: '100px' }})).inject(inputTbody);
        inputTbody.inject(tbl);
        var outputTbody = new Element('tbody', { 'class': 'task_outputs' });
        tr = new Element('tr');
        th = new Element('th', { html: 'Outputs' });
        th.inject(tr);
        tr.inject(outputTbody);
        (new Element('div', { styles: { height: '100px' }})).inject(outputTbody);
        outputTbody.inject(tbl);
        return tbl;
    });

    window.addTaskEditor = function(theTask) {
        var newTable = theTask.toElement();
        newTable.inject($('task_editors'));
    };

    window.addTableEditor = function(theTask, theTable) {
    };

window.addEvent('domready', function() {
    window.TheTarget = new Zonk_Target();
    window.TheApp = new Zonk_Application('Application', window.TheTarget);

    $$('div[data-action]').each(function(d) {
        // split data-action on space; first is action function name, second is argument object
        var a = d.attributes['data-action'].value.split(' ');
        var action = a[0];
        if (action == 'addTask') {
            d.addEvent('click', function(event) {
                var theNewTask = new Zonk_Task('Task', window.TheApp);
                // now add the representation of a task
                window.addTaskEditor(theNewTask);
                return true;  // keep the click enabled
            });
        } else {
            d.addEvent('click', function(event) {
                var cls = window[a[1]];
                if (cls) {

                }
            });
        }
    });
});


})(document.id);
