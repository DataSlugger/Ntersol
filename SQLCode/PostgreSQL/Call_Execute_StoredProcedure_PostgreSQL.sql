  CALL etl_merge_mlbscores();

    TRUNCATE TABLE stage_mlbscores;

      DROP TABLE if exists stage_mlbscores