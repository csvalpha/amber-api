### Checklist
- [ ] databasemigraties samengevoegd in 1 databasemigratie
- [ ] databasemigraties getest vanaf `origin/staging` (`git checkout staging ; git pull ; bundle exec rails db:reset ; git checkout BRANCH ; bundle exec rails db:migrate`)

### Samenvatting
Geef een korte samenvatting van de wijzigingen in deze pull request. Zijn er gerelateerde issues die hiermee opgelost worden? Benoem deze dan (met 'fixes #xyz', zie https://github.com/blog/1506-closing-issues-via-pull-requests), zodat ze automatisch worden opgelost als de pull request wordt gemerget.

### Overige informatie
Als er nog iets anders belangrijk en relevant voor deze pull request is, benoem dat dan hier. Denk bijvoorbeeld aan gerelateerde pull requests (ook in `amber-ui`), nieuw geïntroduceerde conventies, gems of andere dependencies die je nu nodig hebt.
