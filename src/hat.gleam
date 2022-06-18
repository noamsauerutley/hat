import gleam/io
import gleam/list

external fn length(List(a)) -> Int =
  "erlang" "length"

external fn uniform(Int) -> Int =
  "rand" "uniform"

fn decrement(int: Int) -> Int {
  int - 1
}

fn length_or_1(list: List(a)) -> Int {
  case length(list) {
    0 -> 1
    length -> length
  }
}

fn select_name(names: List(String)) -> Result(String, Nil) {
  names
  |> length_or_1
  |> uniform
  |> decrement
  |> list.at(names, _)
}

pub fn pull(names: List(String)) -> Nil {
  case select_name(names) {
    Ok(name) -> io.println(name)
    Error(Nil) -> io.println("oops")
  }
}

pub fn main() {
  io.println("✨")
}
