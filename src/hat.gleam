import gleam/list

pub external type State

/// A type for representing generators.
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

pub fn select_name(names: List(bit_string)) -> Generator(Result(bit_string, Nil)) {
  names
  |> length
  |> pick_within
  |> map(fn(n) { list.at(names, n) })
}
