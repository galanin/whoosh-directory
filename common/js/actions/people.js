import { ADD_PEOPLE } from '@constants/people';

export const addPeople = people => ({
  type: ADD_PEOPLE,
  people
});
