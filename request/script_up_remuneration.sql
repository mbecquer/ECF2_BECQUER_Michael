-- - Augmenter tous les salaires des collaborateurs de  5% si ils ont plus de 5 ans d’ancienneté.
UPDATE collaborateur SET remuneration = remuneration * 1.05 WHERE extract(year from current_date) -  extract(year from date_embauche) > 5;