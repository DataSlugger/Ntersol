SELECT EXISTS (
   SELECT 1
   FROM   information_schema.tables 
   WHERE  table_schema like 'pg_temp_%'
   AND table_name=LOWER('TempMLBScores')
);

  drop TABLE if EXISTS PUBLIC.Stage_MLBScores;

