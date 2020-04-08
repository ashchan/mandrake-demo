/// Ref: https://medium.com/nervosnetwork/whats-animagus-part-2-running-it-for-real-17a48608389d#6aaf

/*
require_relative "ast_pb"

def build_execution_node(query_cell_node)
  get_capacity_function = Ast::Value::new(
    t: Ast::Value::Type::GET_CAPACITY,
    children: [
      Ast::Value::new(
        t: Ast::Value::Type::ARG,
        u: 0
      )
    ]
  )
  capacities = Ast::Value::new(
    t: Ast::Value::Type::MAP,
    children: [
      get_capacity_function,
      query_cell_node
    ]
  )

  add_balance_function = Ast::Value::new(
    t: Ast::Value::Type::ADD,
    children: [
      Ast::Value::new(
        t: Ast::Value::Type::ARG,
        u: 0
      ),
      Ast::Value::new(
        t: Ast::Value::Type::ARG,
        u: 1
      )
    ]
  )
  initial_balance = Ast::Value::new(
    t: Ast::Value::Type::UINT64,
    u: 0
  )
  Ast::Value::new(
    t: Ast::Value::Type::REDUCE,
    children: [
      add_balance_function,
      initial_balance,
      capacities
    ]
  )
end

def build_root(name, node)
  Ast::Root::new(
    calls: [
      Ast::Call::new(
        name: name,
        result: node
      )
    ]
  )
end

*/
