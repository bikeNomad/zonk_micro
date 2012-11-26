//  Zonk! Micro
//  Ned Konz
//  requires mootools 1.3+

//  Application class
var Zonk_Application = new Class(function(name) {
    this.name = name;
    this.tasks = [];
    this.target = null;
});

Zonk_Application.implement({
    addTask: function(task) {
        this.tasks << task;
    },
});

//  Task class
var Zonk_Task = new Class(function(name) {
    this.name = name;
});

Zonk_Task.implement({
});

//  Rule class
var Zonk_Rule = new Class(function(task, name) {
    this.name = name;
});

Zonk_Rule.implement({
});

//  Target class
var Zonk_Target = new Class(function(name) {
    this.name = name;
});

Zonk_Target.implement({
});
