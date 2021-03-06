//  Zonk! Micro
//  Ned Konz
//  requires mootools 1.3+

var Zonk_Base = new Class({
    name: null,

    initialize: function(name) {
        this.name = name;
    },
});

var Zonk_Port = new Class({
    Extends: Zonk_Base,

    capabilities: [],
    valueRange: [],
    className: '',

    initialize: function(name) {
        this.parent(name);
    },

    // return true if val is within my valueRange
    checkRange: function(val) {
        if (this.valueRange.contains(val))
          return true;
        if (this.valueRange.length == 2) {
            if (val >= this.valueRange[0]
                && val <= this.valueRange[1])
                  return true;
        }
        alert("value " + val + " is not within range " + this.valueRange);
        return false;
    }
});

var Zonk_InputPort = new Class({
    Extends: Zonk_Port,
    capabilities: ['input'],

    initialize: function(name) {
        this.parent(name);
    }
});

var Zonk_OutputPort = new Class({
    Extends: Zonk_InputPort,

    initialize: function(name) {
        this.parent(name);
        this.capabilities.append(['output']);
    }
});

var Zonk_DigitalPort = new Class({
    valueRange: [false, true],
    conditions: [ ['isOff'], ['isOn'], ['==', [false,true]] ],
    isOn: function() { this.value() == true; },
    isOff: function() { this.value() == false; },
});

var Zonk_AnalogPort = new Class({
    valueRange: [0.0, 1.0],
    conditions: [
        ['valueIsLessThan', Number],
        ['valueIsGreaterThan', Number],
        ['valueIsLessThanOrEqualTo', Number],
        ['valueIsGreaterThanOrEqualTo', Number] ],
});

var Zonk_DigitalInput = new Class({
    Extends: Zonk_InputPort,
    Implements: Zonk_DigitalPort,

    initialize: function(name) {
        this.parent(name);
        this.className = 'Zonk_DigitalInput';
    }
});

var Zonk_DigitalOutput = new Class({
    Extends: Zonk_OutputPort,
    Implements: Zonk_DigitalPort,

    initialize: function(name) {
        this.parent(name);
        this.className = 'Zonk_DigitalOutput';
    }
});

var Zonk_AnalogInput = new Class({
    Extends: Zonk_InputPort,
    Implements: Zonk_AnalogPort,

    initialize: function(name) {
        this.parent(name);
        this.className = 'Zonk_AnalogInput';
    }
});

var Zonk_AnalogOutput = new Class({
    Extends: Zonk_OutputPort,
    Implements: Zonk_AnalogPort,

    initialize: function(name) {
        this.parent(name);
        this.className = 'Zonk_AnalogOutput';
    }
});

var Zonk_Condition = new Class({
    receiver: null,
    symbol: null,

    initialize: function(rcvr, sym) {
        this.receiver = rcvr;
        this.symbol = sym;
    },
});

//  Rule class
var Zonk_Rule = new Class({
    Extends: Zonk_Base,

    conditions: [],
    actions: [],

    initialize: function(name)  {
        this.parent(name);
    },
});

//  Table class
var Zonk_Table = new Class({
    Extends: Zonk_Base,

    initialize: function(name)  {
        this.parent(name);
    },

    rules: [],

    addRules: function(newrules) {
        newrules.each(function(rule) {
            this.rules.include(rule);
            rule.task = this;
        }, this);
    },

    addRule: function(rule) {
        this.addRules(Array.from(rule));
    },
});

//  Task class
var Zonk_Task = new Class({
    Extends: Zonk_Base,

    initialize: function(name, application) {
        this.parent(name);
        if (application)
            application.addTask(this);
    },

    ports: [],
    tables: [],
    timers: [],

    addPort: function(port) {
        this.ports.push(port);
    },

    addTable: function(table) {
        this.tables.push(table);
    },

    addTimer: function(timer) {
        this.timers.push(timer);
    },

    getOutputs: function() {
        return this.ports.filter(function(port) {
            port.capabilities().some(function(capa) { capa == 'output' })
        }, this);
    },

    getInputs: function() {
        return this.ports.filter(function(port) {
            port.capabilities().some(function(capa) { capa == 'input' })
        }, this);
    }
});

//  Application class
var Zonk_Application = new Class({
    Extends: Zonk_Base,

    initialize: function(name) {
        this.parent(name);
    },

    ports: [],
    tasks: [],

    addTasks: function(tasks) {
        tasks.each(function(task) { this.tasks.include(task); }, this);
    },

    addTask: function(task) {
        this.addTasks(Array.from(task));
    },

    lastTask: function() {
        return this.tasks[ this.tasks.length - 1 ];
    }
});

//  Target class
var Zonk_Target = new Class({
    name: null,
    application: null,

    initialize: function(name, app) {
        this.name = name;
        this.application = app;
    },
});

