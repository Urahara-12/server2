OK='[OK]     '
WARN='[WARN]   '
ERROR='[ERROR]  '
RUNNING=' __  ___ __  __  ______  ______  __  ______  ______
/\ \/ ___\ \/\ \/\  __ \/\  __ \/\ \/\  __ \/\  __ \
\ \  /___/\ \_\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \_\ \
 \ \_\   \ \_____\ \_\ \ \ \_\ \ \ \_\ \_\ \_\ \___  \
  \/_/    \/_____/\/_/\/_/\/_/\/_/\/_/\/_/\/_/\/___/\ \
 __________________________________________________\_\ \
/\______________________________________________________\
\/______________________________________________________/'

assert() {
    exit_code="$?"
    [ "$exit_code" = 0 ] && ([ -z "$1" ] || echo "$OK$1") || (
    [ -z "$2" ] || echo "$ERROR$2 - exit code:$exit_code")
}

echo "$RUNNING"
echo "${WARN}creating tables from schema"

c:/xampp/mysql/bin/mysql.exe -hlocalhost -uroot < web/schema.sql #connects to host and send my schema.sql
assert "created successfully" "your sql sucks"
echo "${WARN}inserting to database"

c:/xampp/mysql/bin/mysql.exe -hlocalhost -uroot app < web/insert.sql #connects to host and send my schema.sql
assert "created successfully" "your sql sucks"
echo "${WARN}get /courses"
echo "response: $(curl -s http://localhost:80/courses)"
assert "success" "failed"
echo "${WARN}get /courses?search=P"
echo "response: $(curl -s http://localhost:80/courses?search=P)"
assert "success" "failed"
echo "${WARN}get /courses?search=Dotabase&page=2"
echo "response: $(curl -s http://localhost:80/courses?search=Dotabase\&page=2)"
assert "success" "failed"
