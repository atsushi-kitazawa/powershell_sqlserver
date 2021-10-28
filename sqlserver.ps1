####################
# constant variable
####################
$server = "127.0.0.1"
$port = 1433
$database = "testdb"
$user = "sa"
$password = "P@ssw0rd"

function select_t1([string]$pServer, [string]$pDatabase, [string]$pUser, [string]$pPassword) {
    # Connection
    $pSQLConnection = New-Object System.Data.SqlClient.SqlConnection
    $pSQLConnection.ConnectionString = "Data Source=$($pServer);Initial Catalog=$($pDatabase);User ID=$($pUser);Password=$($pPassword)"
    $pSQLConnection.Open()
    
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

    # Close Connection
    $pSQLConnection.Close()
}

function select_varbinary([string]$pServer, [string]$pDatabase, [string]$pUser, [string]$pPassword) {
    # Connection
    $pSQLConnection = New-Object System.Data.SqlClient.SqlConnection
    $pSQLConnection.ConnectionString = "Data Source=$($pServer);Initial Catalog=$($pDatabase);User ID=$($pUser);Password=$($pPassword)"
    $pSQLConnection.Open()

    # Query
    $query = "select file_contents from t2"

    # Command
    [System.Data.SqlClient.SqlCommand]$cmd = New-Object System.Data.SqlClient.SqlCommand($query, $pSQLConnection)

    # Execute and Get scalar value
    [byte[]]$return = $cmd.ExecuteScalar()
    
    # Close Connection
    $pSQLConnection.Close()

    # Result to pipe
    return $return
}

function insert_file_to_varbinary([string]$pServer, [string]$pDatabase, [string]$pUser, [string]$pPassword, [string]$pFilename, [string]$pFilepath) {
        # Connection
        $pSQLConnection = New-Object System.Data.SqlClient.SqlConnection
        $pSQLConnection.ConnectionString = "Data Source=$($pServer);Initial Catalog=$($pDatabase);User ID=$($pUser);Password=$($pPassword)"
        $pSQLConnection.Open()
    
        # Query
        $query = "insert into t2(file_id, file_contents) select '{0}' as file_id, * from OPENROWSET(BULK N'{1}', SINGLE_BLOB) AS file_contents"
        $query = [String]::Format($query, $pFilename, $pFilepath)
    
        # Command
        [System.Data.SqlClient.SqlCommand]$cmd = New-Object System.Data.SqlClient.SqlCommand($query, $pSQLConnection)
    
        # Execute and Get scalar value
        $ret = $cmd.ExecuteNonQuery()
        Write-Output $ret

        # Close Connection
        $pSQLConnection.Close()
}

function main() {
    #select_t1 -pServer "$server,$port" -pDatabase $database -pUser $user -pPassword $password

    #select_varbinary -pServer "$server,$port" -pDatabase $database -pUser $user -pPassword $password | Set-Content "sqlcmd.bin" -Encoding Byte

    insert_file_to_varbinary -pServer "$server,$port" -pDatabase $database -pUser $user -pPassword $password -pFileName "aaa.txt" -pFilepath '/var/opt/mssql/data/aaa.txt'
}

main