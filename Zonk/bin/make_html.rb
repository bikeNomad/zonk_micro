$: << 'lib'
$: << 'examples'
require 'zonk'
require 'simple_task'

$app = make_application
$tbl = $app.tasks.first.tables.first
puts $tbl.as_html
