-- Análise de Renda de Bilheteria — Brasileirão Série A 2025
-- Autor: Henrique Bordin Longhi
-- Ferramenta: SQLite
-- Dataset: Campeonato Brasileiro de Futebol (Kaggle)


-- 1. RECONHECIMENTO DO DATASET
-- Verificação dos anos com renda de bilheteria disponível
-- Conclusão: apenas a temporada 2025 possui dados de arrecadação
-- ------------------------------------------------------------

SELECT 
    substr(data, 7, 4) AS ano,
    COUNT(*) AS total_jogos,
    COUNT(arrecadacao) AS jogos_com_arrecadacao
FROM campeonatobrasileirofull
GROUP BY ano
ORDER BY ano DESC;


-- ------------------------------------------------------------
-- 2. VISÃO GERAL DA TEMPORADA 2025
-- Total de jogos, arrecadação total, média e extremos
-- Insight: a diferença entre o jogo mais e menos lucrativo é de quase 97x 
-- ------------------------------------------------------------

SELECT 
    COUNT(*) AS total_jogos,
    SUM(arrecadacao) AS arrecadacao_total,
    AVG(arrecadacao) AS media_arrecadacao,
    MAX(arrecadacao) AS jogo_mais_lucrativo,
    MIN(arrecadacao) AS jogo_menos_lucrativo
FROM campeonatobrasileirofull
WHERE arrecadacao IS NOT NULL;


-- ------------------------------------------------------------
-- 3. RANKING DE JOGOS POR ARRECADAÇÃO
-- Todos os jogos ordenados por renda decrescente
-- Insight: dos 10 jogos mais lucrativos, todos têm o Flamengo
-- como mandante. O primeiro jogo sem o Flamengo aparece só
-- na posição 12 (Santos x Vasco arrecadando R$ 4,3 milhões)
-- ------------------------------------------------------------

SELECT 
    id, 
    data, 
    mandante, 
    visitante, 
    arrecadacao 
FROM campeonatobrasileirofull 
WHERE arrecadacao IS NOT NULL
ORDER BY arrecadacao DESC;


-- ------------------------------------------------------------
-- 4. RECEITA TOTAL E MÉDIA POR TIME MANDANTE
-- Insights:
-- Flamengo gerou R$ 81,7 Mi — quase 50% a mais que o 2º (Corinthians R$ 54 Mi)
-- Flamengo sozinho superou Vasco + São Paulo + Grêmio + Bahia juntos
-- SP e RJ concentram ~45% de toda a receita do campeonato
-- Diferença entre 1º (Flamengo) e último (Bragantino) é de 23x
-- ------------------------------------------------------------

SELECT 
    mandante,
    COUNT(*) AS jogos_em_casa,
    SUM(arrecadacao) AS receita_total,
    AVG(arrecadacao) AS media_por_jogo
FROM campeonatobrasileirofull
WHERE arrecadacao IS NOT NULL
GROUP BY mandante
ORDER BY receita_total DESC;


-- ------------------------------------------------------------
-- 5. ARRECADAÇÃO MÉDIA POR DIA DA SEMANA
-- Conversão da data do formato brasileiro (DD/MM/AAAA)
-- para o formato aceito pelo strftime (AAAA-MM-DD)
-- Insight: jogos de domingo rendem 71% mais que jogos de terça
-- ------------------------------------------------------------

SELECT 
    CASE strftime('%w', substr(data, 7, 4) || '-' || substr(data, 4, 2) || '-' || substr(data, 1, 2))
        WHEN '0' THEN 'Domingo'
        WHEN '1' THEN 'Segunda'
        WHEN '2' THEN 'Terça'
        WHEN '3' THEN 'Quarta'
        WHEN '4' THEN 'Quinta'
        WHEN '5' THEN 'Sexta'
        WHEN '6' THEN 'Sábado'
    END AS dia_semana,
    COUNT(*) AS jogos,
    AVG(arrecadacao) AS media_arrecadacao
FROM campeonatobrasileirofull
WHERE arrecadacao IS NOT NULL
GROUP BY dia_semana
ORDER BY media_arrecadacao DESC;


-- ------------------------------------------------------------
-- 6. ARRECADAÇÃO MÉDIA POR RODADA
-- Insight contraintuitivo: o número da rodada não determina
-- a arrecadação. A rodada de maior renda foi a 15ª e a de
-- menor foi a 16ª, sem padrão claro. O fator determinante
-- é o confronto em si, não o momento do campeonato.
-- ------------------------------------------------------------

SELECT 
    rodata,
    COUNT(*) AS jogos,
    AVG(arrecadacao) AS media_arrecadacao
FROM campeonatobrasileirofull
WHERE arrecadacao IS NOT NULL
GROUP BY rodata
ORDER BY media_arrecadacao DESC;


-- ------------------------------------------------------------
-- 7. TOP 25 CONFRONTOS MAIS LUCRATIVOS
-- Insight: 15 dos 25 jogos mais lucrativos têm o Flamengo
-- como mandante. O restante são confrontos de alto apelo
-- regional entre grandes clubes.
-- ------------------------------------------------------------

SELECT
    mandante || ' x ' || visitante AS confronto,
    data,
    ROUND(arrecadacao, 0) AS arrecadacao
FROM campeonatobrasileirofull
WHERE arrecadacao IS NOT NULL
ORDER BY arrecadacao DESC
LIMIT 25;


-- ------------------------------------------------------------
-- 8. APARIÇÕES NO TOP 25 POR MANDANTE (SUBCONSULTA)
-- Quantas vezes cada time aparece entre os 25 jogos
-- mais lucrativos da temporada
-- ------------------------------------------------------------

SELECT 
    mandante AS time,
    COUNT(*) AS aparicoes_top25
FROM (
    SELECT mandante, arrecadacao
    FROM campeonatobrasileirofull
    WHERE arrecadacao IS NOT NULL
    ORDER BY arrecadacao DESC
    LIMIT 25
) AS top25
GROUP BY mandante
ORDER BY aparicoes_top25 DESC;


-- ------------------------------------------------------------
-- 9. TIMES ACIMA DA MÉDIA DO CAMPEONATO (CTE)
-- Utiliza duas CTEs encadeadas:
-- media_geral: calcula a média do campeonato inteiro
-- receita_por_time: calcula a média de cada mandante
-- Resultado: apenas 8 dos 20 times superam a média geral
-- ------------------------------------------------------------

WITH media_geral AS (
    SELECT AVG(arrecadacao) AS media_campeonato
    FROM campeonatobrasileirofull
    WHERE arrecadacao IS NOT NULL
),
receita_por_time AS (
    SELECT 
        mandante,
        ROUND(AVG(arrecadacao), 0) AS media_time,
        COUNT(*) AS jogos_em_casa
    FROM campeonatobrasileirofull
    WHERE arrecadacao IS NOT NULL
    GROUP BY mandante
)
SELECT 
    r.mandante,
    r.jogos_em_casa,
    r.media_time,
    ROUND(m.media_campeonato, 0) AS media_campeonato,
    ROUND(r.media_time - m.media_campeonato, 0) AS diferenca
FROM receita_por_time r, media_geral m
WHERE r.media_time > m.media_campeonato
ORDER BY r.media_time DESC;
