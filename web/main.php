<?php
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: GET, OPTIONS');
    header('Access-Control-Max-Age: 1728000');
    header('Content-Length: 0');
    header('Content-Type: text/plain');
    die();
}

header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

$conx = mysqli_connect('localhost', 'root', '', 'app');
if (!$conx) {
    http_response_code(500);
    echo json_encode(['details' => mysqli_connect_error()]);
    mysqli_close($conx);
    die();
}

$req_uri = '/'.strtok($_SERVER["REQUEST_URI"], '/?');
$resp_data = array();

switch ($req_uri) {
    case '/courses':
        if ($_SERVER['REQUEST_METHOD'] === 'GET') {
            parse_str($_SERVER['QUERY_STRING'], $query_params);
            $page = array_key_exists('page', $query_params)
                ? intval($query_params['page']) : 1;
            $search = array_key_exists('search', $query_params)
                ? $query_params['search'] : '';
            $search_course_clause = empty($search) ? '' :
                " and (name like '%$search%'
                  or name sounds like '%$search%'
                  or description like '%$search%'
                  or description sounds like '%$search%')";
            $search_other_clause = empty($search) ? '' :
                " where tmp_course.name like '%$search%'
                  or tmp_course.name sounds like '%$search%'
                  or tmp_course.description like '%$search%'
                  or tmp_course.description sounds like '%$search%'
                  or professor.name like '%$search%'
                  or professor.name sounds like '%$search%'
                  or department.name like '%$search%'
                  or department.name sounds like '%$search%'";
            $count_sql = "select @rows:= auto_increment -1 as 'rows'
                                 , @estimate:= @rows - @rows % 5 as 'estimate'
                                 , @estimate < @rows AS 'more'
                            from information_schema.tables
                           where table_schema='app'
                             and table_name='course';";
            $result = mysqli_query($conx, $count_sql);
            $count = mysqli_fetch_assoc($result);
            $last = ceil(intval($count['rows'])/3);
            $page = $page > $last ? $last : $page;
            $tmp_course_sql = "create temporary table if not exists tmp_course
                               select id, name, description, professor_id
                                 from course
                                where id <= {$count['rows']} - ($page - 1) * 3
                                $search_course_clause
                                order by id desc
                                limit 3;";
            mysqli_query($conx, $tmp_course_sql);
            $course_sql = "select tmp_course.id, tmp_course.name, description
                                  , professor.name as professor
                                  , department.name as department
                             from tmp_course
                             left join professor
                                  on professor_id=professor.id
                             left join department
                                  on department_id=department.id
                                  $search_other_clause;";
            $result = mysqli_query($conx, $course_sql);
            $resp_data['rows'] = empty($search) ? intval($count['rows']): mysqli_num_rows($result);
            $resp_data['estimate'] = empty($search) ? intval($count['estimate']) : $resp_data['rows'] % 5;
            $resp_data['more'] = empty($search) ? boolval($count['more']) : $resp_data['estimate'] < $resp_data['rows'];
            mysqli_query($conx, "drop temporary table if exists tmp_course;");
            $resp_data['result'] = mysqli_fetch_all($result, MYSQLI_ASSOC);
            $resp_data['page'] = $page;
            $resp_data['previous'] = $page > 1 ? "/#/page/".strval($page - 1)."?search=$search" : null;
            $resp_data['next'] = $page < $resp_data['rows'] / 3 ? "/#/page/".strval($page + 1)."?search=$search" : null;
        } else {
            $resp_data['details'] = 'Method Not Allowed';
            http_response_code(405);
        }
        break;

    default:
        http_response_code(404);
        $resp_data['details'] = 'Not Found';
        break;
}

$json = json_encode($resp_data);
if ($json === false) {
    $json = json_encode(['details' => json_last_error_msg()]);
    http_response_code(500);
    if ($json === false) {
        $json = '{"details": "Internal Server Error"}';
    }
}
echo $json;
mysqli_close($conx);
?>
