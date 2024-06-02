DROP VIEW IF EXISTS _group_users;

DROP VIEW IF EXISTS _user_groups;

CREATE VIEW _group_users AS
    SELECT group_.group_id, group_name, group_description
    , group_concat(group_user_.user_id) AS users_id
    , group_concat(user_name) AS users_name
    FROM user_, group_, group_user_
    WHERE group_user_.group_id=group_.group_id
    AND user_.user_id=group_user_.user_id
    GROUP BY group_.group_id
    UNION
    SELECT group_.group_id, group_name, group_description
    , "" AS users_id
    , "" AS users_name
    FROM group_
    WHERE group_id IN (SELECT group_id FROM group_ WHERE group_id NOT IN (SELECT DISTINCT group_id FROM group_user_));

CREATE VIEW _user_groups AS
      SELECT user_.user_id, user_name, user_password
           , group_concat(group_user_.group_id) AS groups_id, group_concat(group_name) as groups_name
        FROM user_, group_, group_user_
        WHERE group_user_.group_id=group_.group_id
         AND user_.user_id=group_user_.user_id
      GROUP BY user_.user_id
  UNION
      SELECT user_.user_id, user_name, user_password, "" AS groups_id, "" AS groups_name
        FROM user_
           WHERE user_id NOT IN (SELECT DISTINCT user_id FROM group_user_);
