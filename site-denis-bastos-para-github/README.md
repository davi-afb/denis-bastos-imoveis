# Dênis Bastos Imóveis

Site do corretor Dênis Bastos (CRECI-AL 7509), Maceió · AL.

- **Página:** `index.html` (HTML, CSS e JavaScript num arquivo só). Publicada na Vercel, projeto `denis-bastos-imoveis`.
- **Fotos:** `fotos/<imóvel>/` (ex.: `fotos/rosa-marina/`). O site as serve em `/fotos/...`.
- **Imóveis:** vêm do Supabase (tabelas `imoveis` e `imovel_fotos`). O `index.html` guarda uma cópia do imóvel Savassi, usada se o Supabase não responder.
- **Contatos:** o formulário grava na tabela `leads` e abre o WhatsApp. Os contatos só podem ser lidos pelo painel do Supabase.
- **Banco:** estrutura em `supabase/schema.sql`.

Para publicar uma mudança: faça o commit na branch `main` e a Vercel publica sozinha.
