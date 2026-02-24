enum PersonaCategory {
  economic('경제력', 'Economic Capacity'),
  health('건강', 'Health'),
  lifeRhythm('생활 리듬', 'Life Rhythm'),
  values('가치관/철학', 'Values & Philosophy');

  const PersonaCategory(this.labelKo, this.labelEn);

  final String labelKo;
  final String labelEn;
}
