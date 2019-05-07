import { ConnectionSource } from '../../types/ConnectionSource';
import { getRepository, FindManyOptions } from 'typeorm';
import { User } from '../../entity/User';
import { PageInfoSource } from '../../types/PageInfoSource';
import { base64Encode } from '../../util/base64Encode';

export const UsersConnection = {
  totalCount: async (src: ConnectionSource<User>) => {
    const options: FindManyOptions<User> = {
      cache: true,
      where: src.conditions || {},
    };

    return getRepository(User).count(options);
  },

  edges: async (src: ConnectionSource<User>) => {
    return src.entities.map(entity => ({
      node: entity,
      cursor: base64Encode(entity.serial.toString()),
    }));
  },

  pageInfo: (src: ConnectionSource<User>): PageInfoSource<User> => ({
    startSerial: src.entities[0].serial,
    endSerial: src.entities[src.entities.length - 1].serial,
    repository: getRepository(User),
    conditions: src.conditions,
  }),
};