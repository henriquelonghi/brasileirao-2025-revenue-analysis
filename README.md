# Análise de Renda de Bilheteria — Brasileirão Série A 2025

## Objetivo

Este projeto analisa a renda de bilheteria dos 380 jogos do Campeonato Brasileiro Série A 2025, buscando responder perguntas reais de negócio que impactam diretamente a receita dos clubes e da federação:

- Quais fatores influenciam a renda de bilheteria nos jogos?
- O dia da semana impacta a arrecadação?
- O momento do campeonato (número da rodada) tem relação com o público pagante?
- Quais times geram mais receita como mandantes?
- A receita está concentrada em poucos clubes ou distribuída pelo campeonato?

---

## Ferramentas

- **SQLite** — armazenamento e análise exploratória dos dados
- **Power BI** — visualização e dashboard interativo
- **Dataset** — [Campeonato Brasileiro de Futebol (Kaggle)](https://www.kaggle.com/datasets/adaoduque/campeonato-brasileiro-de-futebol)

---

## Principais Descobertas

**Concentração extrema de renda**
A diferença entre o jogo mais lucrativo (R$ 5,98 Mi) e o menos lucrativo (R$ 61,8 Mil) da temporada é de quase 97x — evidenciando uma disparidade brutal na capacidade de geração de receita entre os clubes.

**Flamengo domina a bilheteria**
O Flamengo gerou R$ 81,7 milhões em renda de bilheteria como mandante — quase 50% a mais que o segundo colocado (Corinthians, R$ 54 Mi). 15 dos 25 jogos mais lucrativos da temporada tiveram o Flamengo como mandante, e apenas 8 dos 20 times superaram a média geral do campeonato (R$ 1,36 Mi por jogo).

**Concentração geográfica**
SP e RJ concentram aproximadamente 45% de toda a renda de bilheteria da temporada. Times do interior ocupam consistentemente as últimas posições no ranking — a diferença entre Flamengo (1º) e Bragantino (20º) é de 23x.

**O dia da semana importa mais que a rodada**
Jogos realizados aos domingos geram em média 71% mais receita do que jogos às terças-feiras. Para clubes e federação, cada jogo transferido de dia útil para o fim de semana representa centenas de milhares de reais a mais em arrecadação.

**Insight contraintuitivo: a rodada não determina a renda**
Ao contrário do esperado, rodadas finais e jogos decisivos não geram maior bilheteria de forma consistente. A rodada de maior média de arrecadação foi a 15ª, e a de menor foi a 16ª — sem padrão claro. O fator determinante é o confronto em si, não o momento do campeonato.

---

## Demonstração

> 📹 [Assista ao dashboard em funcionamento](#) *(link do vídeo)*

---

## Estrutura do Repositório

```
brasileirao-2025-revenue-analysis/
│
├── README.md
├── queries.sql         # Todas as consultas SQL com comentários e insights
└── data/
    └── campeonato-brasileiro-full.csv
```

---

## Como Reproduzir

1. Baixe o dataset no [Kaggle](https://www.kaggle.com/datasets/adaoduque/campeonato-brasileiro-de-futebol)
2. Importe o arquivo `.csv` no SQLite (recomendado: [DB Browser for SQLite](https://sqlitebrowser.org/))
3. Execute as queries do arquivo `queries.sql` na ordem numerada
4. Conecte o Power BI no arquivo `.db` gerado para reproduzir o dashboard

---

*Projeto desenvolvido como parte do portfólio de análise de dados.*
