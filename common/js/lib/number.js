import { padStart } from 'lodash';

export const padNumber = (number, length) => {
  if (!length) {
    length = 2;
  }
  const number_str = number.toString();
  return padStart(number_str, length, '0');
};
