####################
# constant variable
####################
$server = "127.0.0.1"
$port = 1433
$database = "testdb"
$user = "sa"
$password = "P@ssw0rd"

function select_t1([System.Data.SqlClient.SqlConnection]$pSQLConnection) {    
    # Query
    $query = "select id, name from t1"

    # Command
    [System.Data.SqlClient.SqlCommand]$cmd = New-Object System.Data.SqlClient.SqlCommand($query, $pSQLConnection)
    
    # Execute and Get scalar value
    [System.Data.SqlClient.SqlDataReader]$rows = $cmd.ExecuteReader()
    
    while ($rows.Read()) {
        Write-Output $rows['id']
        Write-Output $rows['name']
    }
    $rows.Close()
}

function select_varbinary([System.Data.SqlClient.SqlConnection]$pSQLConnection) { 
    # Query
    $query = "select file_contents from t2"

    # Command
    [System.Data.SqlClient.SqlCommand]$cmd = New-Object System.Data.SqlClient.SqlCommand($query, $pSQLConnection)

    # Execute and Get scalar value
    [byte[]]$return = $cmd.ExecuteScalar()

    # Result to pipe
    return $return
}

function insert_file_to_varbinary([System.Data.SqlClient.SqlConnection]$pSQLConnection, [string]$pFilename, [string]$pFilepath) {    
    # Query
    $query = "insert into t2(file_id, file_contents) select '{0}' as file_id, * from OPENROWSET(BULK N'{1}', SINGLE_BLOB) AS file_contents"
    $query = [String]::Format($query, $pFilename, $pFilepath)
    
    # Command
    [System.Data.SqlClient.SqlCommand]$cmd = New-Object System.Data.SqlClient.SqlCommand($query, $pSQLConnection)
    
    # Execute and Get scalar value
    $ret = $cmd.ExecuteNonQuery()
    Write-Output $ret
}

function openConnection([string]$pServer, [string]$pDatabase, [string]$pUser, [string]$pPassword) {
    $pSQLConnection = New-Object System.Data.SqlClient.SqlConnection
    $pSQLConnection.ConnectionString = "Data Source=$($pServer);Initial Catalog=$($pDatabase);User ID=$($pUser);Password=$($pPassword)"
    $pSQLConnection.Open()
    return $pSQLConnection
}

function closeConnection([System.Data.SqlClient.SqlConnection]$pSQLConnection) {
    $pSQLConnection.Clone()
}

function main() {
    # open connection
    $conn = openConnection -pServer "$server,$port" -pDatabase $database -pUser $user -pPassword $password

    # exec querys
    select_t1 -pSQLConnection $conn
    select_varbinary -pSQLConnection $conn | Set-Content "sqlcmd.bin" -Encoding Byte
    insert_file_to_varbinary -pSQLConnection $conn -pFileName "bbb.txt" -pFilepath '/var/opt/mssql/data/aaa.txt'

    # close connection
    closeConnection -pSQLConnection $conn | Out-Null
}

main