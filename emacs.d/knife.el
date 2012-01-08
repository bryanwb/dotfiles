(setq knife-types '("data_bags" "cookbooks" "environments" "roles"))
(setq knife-path-list (split-string (buffer-file-name) "/" t))
(setq knife-file-name (car (last knife-path-list)))
(butlast knife-path-list)
(setq knife-path (
(filter knife-types (string-equal

(pop (split-string (buffer-file-name) "/" t))

(provide 'knife)
