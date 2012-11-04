require "minitest/autorun"
require "zonk"

class TestTasks < MiniTest::Unit::TestCase
  include Zonk

  def test_app_construction
    myapp = Application.new('myapp')
    assert_empty(myapp.tasks)

    task1 = Task.new('task1')
    assert_nil(task1.owner)
    myapp.add_task(task1)
    assert_equal(myapp, task1.owner)

    refute_empty(myapp.tasks, "must have defined a task")
    assert_equal(1, myapp.tasks.size, "must have defined a task")
    assert_equal(myapp.tasks.first, task1, "first task must be task1")
  end

  def test_app_construction_2
    myapp = Application.new('myapp')
    assert_empty(myapp.tasks)

    task1 = Task.new('task1', myapp)
    assert_equal(myapp, task1.owner)
    refute_empty(myapp.tasks, "must have defined a task")
  end

  def test_table_construction
    task1 = Task.new
    assert_empty(task1.tables, "must have no tables yet")
    table1 = Table.new('table1')
    task1.add_table(table1)
    assert_equal(task1, table1.owner)
    assert_equal(1, task1.tables.size, "must have one table now")
    assert_same(task1, table1.owner, "table must be owned by task")
  end

  def test_multiple_tasks
    myapp = Application.new('myapp')
    task1 = Task.new('task1', myapp)
    assert_equal(myapp, task1.owner)
    assert_equal(1, myapp.tasks.size, "must have defined a task")
    assert_equal(myapp.tasks.first, task1, "first task must be task1")

    task2 = Task.new('task2', myapp)
    assert_equal(2, myapp.tasks.size, "must have defined another task")
    assert_equal(myapp.tasks.first, task1, "first task must be task1")
    assert_equal(myapp.tasks.last, task2, "last task must be task2")
  end
end

