.mode csv
.import 'pooldump.stdout' data
.headers on

CREATE TABLE NSThread AS
SELECT DISTINCT thread_id, thread AS thread_name
FROM data;

CREATE TABLE NSAutoreleasePool AS
SELECT DISTINCT pool_id, pool AS pool_name, thread_id
FROM data;

CREATE TABLE pool_objects AS
SELECT DISTINCT pool_id, thread_id, object_id
FROM data;

CREATE TABLE objects AS
SELECT
    object_id,
    object AS object_name,
    class AS class_name,
    rc AS retain_count,
    (SELECT COUNT(*) FROM data AS d WHERE d.object_id = data.object_id) AS pool_count
FROM
    data
GROUP BY
    object_id, object, class, rc;

