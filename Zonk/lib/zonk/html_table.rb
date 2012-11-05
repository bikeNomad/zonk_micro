# HTML generation for table display
require_relative 'rules'

# Table name
#
# -----------------------------------------------------------
# RULE:       | Rule1 name           | Rule2 name           |
# -----------------------------------------------------------
# EVENT:      | Rule1 event pattern  | Rule2 event pattern  |
# -----------------------------------------------------------
# port1 name  | Rule1 cond for port1 | Rule2 cond for port1 |
# port2 name  | Rule1 cond for port2 | Rule2 cond for port2 |
# -----------------------------------------------------------
# oport1 name | Rule1 act for oport1 | Rule2 act for oport1 |
# oport2 name | Rule1 act for oport2 | Rule2 act for oport2 |
# -----------------------------------------------------------

module Zonk
  class EventPattern
    def as_html
      "#{source.name} #{kinds.to_s.tr('_', ' ')}"
    end
  end

  class CompositeCondition
    def as_html_for_rcvr(r)
      retval = conditions.collect { |c| (c.method.receiver == r) ? c.method.name : nil }
      retval.compact.join(' AND ')
    end

    def condition_sources
      conditions.collect(&:method).collect(&:receiver).uniq
    end
  end

  class Rule
    def actions_for_rcvr(r)
      actions.select { |act| port(act.first) == r }.map { |a| a[1] }
    end

    def action_receivers
      actions.collect { |act| port(act.first) }.uniq
    end
  end

  class Table 
    include Zonk

    def html(tag, opts={})
      retval = []
      retval << sprintf("<%s %s>", tag, opts.collect { |k,v| "#{k}=\"#{v}\""}.join(' ') )
      if block_given?
        retval << yield
      end
      retval << sprintf("</%s>", tag)
      retval.join('')
    end

    def event_sources
      rules.collect { |r| r.pattern.source }.uniq
    end

    def condition_sources
      rules.collect { |rule| rule.condition.condition_sources }.flatten.uniq
    end

    def event_outputs
      rules.collect { |rule| rule.action_receivers }.flatten.uniq
    end

    def as_html
      retval = []
      retval << html('h1') { name }
      retval << html('table', :class => "dtable", :id => "table_#{name}") do
        rv = []
        # header
        rv << html('tr', :class => "rulenames") do
          (['<th>RULE:</th>'] + rules.collect { |rule| html('th') { rule.name } }).join('')
        end
        # events
        rv << html('tr', :class => "event") do
          html('th', :class => "label") { 'EVENT:' } +
          (rules.collect { |rule| html('td', :class => "pattern") { rule.pattern.as_html } }).join('')
        end
        # conditions
        rv.concat(condition_sources.collect do |s|
          html('tr', :class => "condition") do
            r = []
            r << html('th', :class => "source") { s.name }
            r.concat(rules.map { |rule| html('td', :class => "cond") { rule.condition.as_html_for_rcvr(s) } })
            r.join('')
          end
        end)
        # actions
        rv.concat(event_outputs.collect do |s|
          html('tr', :class => "actions") do
            r = []
            r << html('th', :class => "output") { s.name }
            r.concat(rules.map { |rule| html('td') { rule.actions_for_rcvr(s).join(', ') }})
            r.join('')
          end
        end)
        rv.join("\n")
      end
      retval.join("\n")
    end
  end
end
