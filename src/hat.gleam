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

fn select_slip(slips: List(String)) -> Result(String, Nil) {
  slips
  |> length_or_1
  |> uniform
  |> decrement
  |> list.at(slips, _)
}

pub fn pull(slips: List(String)) -> Nil {
  case select_slip(slips) {
    Ok(slip) -> io.println(slip)
    Error(Nil) -> io.println("oops")
  }
}

pub fn main() {
  io.println("✨")
}
