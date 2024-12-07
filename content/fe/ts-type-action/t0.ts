interface Config {
    name: string
    age: number
}

export function mergeConfig(c, k, v) {
    c[k] = v
}

const s1: Config = {
    name: 'dd',
    age: 1
}

mergeConfig(s1, 'name', 11)
mergeConfig(s1, 'nothing', 11)