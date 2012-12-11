// set up app editor with a sample
// MooTools

// $() is the same as document.id() inside the closure
(function($) {

    var Zonk_TaskEditor = new Class({
        Implements: Events,

        initialize: function(task) {
        },

        addInput: function() {
        },

        addOutput: function() {
        },

        addEmptyRule: function() {
        },

        addRule: function() {
        },
    });

    // return a table editor
    Zonk_Task.implement('toElement', function() {
        var tbl = new Element('table', { 'class': 'task_editor' });
        // var tbody = tbl.createTBody();
        // tbl.insertRow(-1);
        return tbl;
    });

    // return a Rule row for insertion into a table editor
    Zonk_Rule.implement('toElement', function() {
    });

    window.addTaskEditor = function(theTask) {
        $('task_editor').appendChild(theTask.toElement())
    };

window.addEvent('domready', function() {
    window.TheApp = new Zonk_Application();

    $$('div[data-action]').each(function(d) {
        // split data-action on space; first is action function name, second is argument object
        var a = d.attributes['data-action'].value.split(' ');
        if (a[0] == 'addTask') {
            d.addEvent('click', function(event) {
                var theNewTask = new Zonk_Task();
                window.TheApp.addTask(theNewTask);
                // now add the representation of a task
                window.addTaskEditor(theNewTask);
                return true;  // keep the click enabled
            });
        } else {
            d.addEvent('click', function(event) {

            });
        }
    });
});


})(document.id);
