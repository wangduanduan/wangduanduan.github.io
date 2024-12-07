interface Config {
    name: string
    age: number
}

export function mergeConfig(c, k, v) {
    c[k] = v
}

// function mergeConfig<T, K extends keyof T> (c: T, k: K, v: T[K]) {
//     c[k] = v
// }

// const s1: Config = {
//     name: 'dd',
//     age: 1
// }

// mergeConfig(s1, 'name', 11)
// mergeConfig(s1, 'nothing', 11)