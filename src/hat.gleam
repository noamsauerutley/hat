import gleam/io
import gleam/list
import gleam/result

external type Algorithm
pub external type State
pub type Generator(a) {
  Generator(fn(State) -> #(State, a))
}

external fn float(Int) -> Float =
  "erlang" "float"

external fn floor(Float) -> Float =
  "math" "floor"

external fn round(Float) -> Int =
  "erlang" "round"

external fn length(List(a)) -> Int =
  "erlang" "length"

external fn uniform_s(State) -> #(Float, State) =
  "rand" "uniform_s"

external fn seed_s(Algorithm) -> State =
  "rand" "seed_s"

external fn default_algorithm() -> Algorithm =
  "algorithm" "default_algorithm"

pub fn second(pair: #(a, b)) -> b {
  let #(_, a) = pair
  a
}

fn map(gen: Generator(a), fun: fn(a) -> b) -> Generator(b) {
  let Generator(f) = gen
  let new_f = fn(seed_0) {
    let #(seed_1, a) = f(seed_0)
    #(seed_1, fun(a))
  }
  Generator(new_f)
}

fn uniform(seed: State) -> #(State, Float) {
  let #(x, next_seed) = uniform_s(seed)
  #(next_seed, x)
}

fn generate_float() -> Generator(Float) {
  let f = fn(seed_0) {
    let #(seed_1, x) = uniform(seed_0)
    #(seed_1, x)
  }
  Generator(f)
}

fn pick_within(n: Int) -> Generator(Int) {
  generate_float()
  |> map(fn(x) {
    x *. float(n)
    |> floor
    |> round
  })
}

pub fn select_name(names: List(String)) -> Generator(Result(String, Nil)) {
  names
  |> length
  |> pick_within
  |> map(fn(n) { list.at(names, n) })
}

pub fn run(gen: Generator(Result(String, Nil))) -> Result(String, Nil) {
  let Generator(f) = gen
  default_algorithm()
  |> seed_s()
  |> f
  |> second
}

pub fn main(){
  select_name(["noam", "mark", "bob", "greg"])
  |> run
  |> result.unwrap
  |> io.println
}