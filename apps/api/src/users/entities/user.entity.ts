import {
  Column,
  CreateDateColumn,
  Entity,
  OneToMany,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { Child } from '../../children/entities/child.entity.js';
import { SocialAccount } from '../../auth/entities/social-account.entity.js';
import { RefreshToken } from '../../auth/entities/refresh-token.entity.js';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 50, unique: true })
  username: string;

  @Column({ type: 'varchar', length: 50, unique: true })
  email: string;

  // Menyimpan hash scrypt (bukan password asli), butuh panjang > 100 karakter.
  @Column({ type: 'varchar', length: 255 })
  password: string;

  @Column({ name: 'terms_accepted_at', type: 'timestamp' })
  terms_accepted_at: Date;

  @CreateDateColumn({ name: 'created_at' })
  created_at: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updated_at: Date;

  @OneToMany(() => Child, (child) => child.user)
  children: Child[];

  @OneToMany(() => SocialAccount, (s) => s.user)
  socialAccounts: SocialAccount[];

  @OneToMany(() => RefreshToken, (t) => t.user)
  refreshTokens: RefreshToken[];
}
