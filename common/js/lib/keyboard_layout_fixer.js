const FIX_TABLE = {
  cyrillic: {
    // eslint-disable-next-line no-useless-escape
    match: /(([qwertyuiop\[\]asdfghjkl;'zxcvbnm,`QWERTYUIOP\{\}ASDFGHJKL:"ZXCVBNM<>~])|(\D)(\.)|^(\.))/,
    func(replace, match, whole, p11, p21, p22, p31) {
      if (p11) {
        return replace[p11];
      } else if (p22) {
        return p21 + replace[p22];
      } else if (p31) {
        return replace[p31];
      } else {
        return match;
      }
    },
    replace: {
      q: 'й',
      w: 'ц',
      e: 'у',
      r: 'к',
      t: 'е',
      y: 'н',
      u: 'г',
      i: 'ш',
      o: 'щ',
      p: 'з',
      '[': 'х',
      ']': 'ъ',
      a: 'ф',
      s: 'ы',
      d: 'в',
      f: 'а',
      g: 'п',
      h: 'р',
      j: 'о',
      k: 'л',
      l: 'д',
      ';': 'ж',
      '\'': 'э',
      z: 'я',
      x: 'ч',
      c: 'с',
      v: 'м',
      b: 'и',
      n: 'т',
      m: 'ь',
      ',': 'б',
      '.': 'ю',
      '`': 'ё',
      Q: 'Й',
      W: 'Ц',
      E: 'У',
      R: 'К',
      T: 'Е',
      Y: 'Н',
      U: 'Г',
      I: 'Ш',
      O: 'Щ',
      P: 'З',
      '{': 'Х',
      '}': 'Ъ',
      A: 'Ф',
      S: 'Ы',
      D: 'В',
      F: 'А',
      G: 'П',
      H: 'Р',
      J: 'О',
      K: 'Л',
      L: 'Д',
      ':': 'Ж',
      '"': 'Э',
      Z: 'Я',
      X: 'Ч',
      C: 'С',
      V: 'М',
      B: 'И',
      N: 'Т',
      M: 'Ь',
      '<': 'Б',
      '>': 'Ю',
      '~': 'Ё'
    }
  }
};

export const fixText = string => {
  const fix_mode = process.env.KEYBOARD_LAYOUT_FIX;
  const fix_table = FIX_TABLE[fix_mode];
  if (fix_table) {
    return string.replace(fix_table.match, (...args) => fix_table.func(fix_table.replace, ...args));
  } else {
    return string;
  }
};
