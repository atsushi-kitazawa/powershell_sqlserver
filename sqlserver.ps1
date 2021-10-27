####################
# constant variable
####################
$server = "127.0.0.1,1433"
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

function main() {
    select_t1 -pServer $server -pDatabase $database -pUser $user -pPassword $password
}

main