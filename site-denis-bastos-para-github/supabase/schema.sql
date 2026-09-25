-- Supabase: projeto denis-bastos-imoveis (ref waakhggazfajbghmtslm, região sa-east-1)
-- Migração aplicada em 25/09/2026. Mantida aqui só como referência.

create table public.imoveis (
  id bigint generated always as identity primary key,
  slug text not null unique,
  titulo text not null,
  tipo text not null,
  bairro text not null,
  cidade text not null default 'Maceió',
  edificio text,
  preco numeric(12,2),
  condominio numeric(10,2),
  iptu numeric(10,2),
  quartos smallint,
  banheiros smallint,
  vagas smallint,              -- NULL = sob consulta
  area_m2 numeric(8,2),
  mobiliado boolean not null default false,
  descricao text,
  destaques text[] not null default '{}',
  publicado boolean not null default true,
  ordem integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.imovel_fotos (
  id bigint generated always as identity primary key,
  imovel_id bigint not null references public.imoveis(id) on delete cascade,
  url text not null,
  legenda text,
  ordem integer not null default 0
);
create index imovel_fotos_imovel_ordem_idx on public.imovel_fotos (imovel_id, ordem);

create table public.leads (
  id bigint generated always as identity primary key,
  nome text not null check (char_length(nome) between 1 and 120),
  telefone text not null check (char_length(telefone) between 8 and 30),
  interesse text check (char_length(interesse) <= 60),
  mensagem text check (char_length(mensagem) <= 2000),
  imovel_id bigint references public.imoveis(id) on delete set null,
  origem text check (char_length(origem) <= 60),
  created_at timestamptz not null default now()
);
create index leads_imovel_id_idx on public.leads (imovel_id);
create index leads_created_at_idx on public.leads (created_at desc);

create or replace function public.set_updated_at()
returns trigger language plpgsql set search_path = '' as $$
begin new.updated_at := now(); return new; end; $$;
create trigger imoveis_set_updated_at before update on public.imoveis
  for each row execute function public.set_updated_at();

alter table public.imoveis enable row level security;
alter table public.imovel_fotos enable row level security;
alter table public.leads enable row level security;

create policy "Imóveis publicados são públicos" on public.imoveis
  for select to anon, authenticated using (publicado);
create policy "Fotos de imóveis publicados são públicas" on public.imovel_fotos
  for select to anon, authenticated
  using (exists (select 1 from public.imoveis i where i.id = imovel_id and i.publicado));
create policy "Visitantes podem enviar contato" on public.leads
  for insert to anon, authenticated with check (true);

revoke update, delete, truncate on public.imoveis, public.imovel_fotos, public.leads from anon, authenticated;
revoke select on public.leads from anon, authenticated;

-- Storage: bucket público "site" (imagem de compartilhamento em og/og-denis-bastos-v1.jpg).
