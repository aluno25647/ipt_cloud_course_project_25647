<?php
include '_dotenv.php';

// Function to handle database connection
function connectToDatabase($db_host, $db_port, $db_name, $db_user, $db_pass)
{
    try {
        return new PDO("pgsql:host=$db_host;port=$db_port;dbname=$db_name", $db_user, $db_pass, [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
        ]);
    } catch (PDOException $e) {
        die("Error: " . $e->getMessage());
    }
}

// Function to truncate the messages table
function truncateTable($pdo)
{
    if (isset($_POST['truncate'])) {
        try {
            // Truncate the table
            $pdo->exec('TRUNCATE TABLE messages');
            header("Location: " . $_SERVER['PHP_SELF'] . "?truncate=success");
            exit();
        } catch (PDOException $e) {
            header("Location: " . $_SERVER['PHP_SELF'] . "?truncate=error");
            exit();
        }
    }
}

// Function to handle message insertion
function handleMessageInsertion($pdo)
{
    if (isset($_POST['submit'])) {
        $message = $_POST['message'];
        $escapedInput = htmlspecialchars($message, ENT_QUOTES, 'UTF-8');

        try {
            // Insert the message into the database
            $stmt = $pdo->prepare("INSERT INTO messages (message) VALUES (?)");
            $stmt->execute([$escapedInput]);
            header("Location: " . $_SERVER['PHP_SELF'] . "?insert=success");
            exit();
        } catch (PDOException $e) {
            header("Location: " . $_SERVER['PHP_SELF'] . "?insert=error");
            exit();
        }
    }
}

// Function to delete a message
function deleteMessage($pdo)
{
    if (isset($_POST['delete'])) {
        $id = $_POST['message_id'];

        try {
            // Delete the message from the database
            $stmt = $pdo->prepare("DELETE FROM messages WHERE id = ?");
            $stmt->execute([$id]);
            header("Location: " . $_SERVER['PHP_SELF'] . "?delete=success");
            exit();
        } catch (PDOException $e) {
            header("Location: " . $_SERVER['PHP_SELF'] . "?delete=error");
            exit();
        }
    }
}

// Function to fetch messages from the database
function fetchMessages($pdo)
{
    $stmt = $pdo->query("SELECT * FROM messages ORDER BY id DESC");
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

$pdo = connectToDatabase($db_host, $db_port, $db_name, $db_user, $db_pass);

truncateTable($pdo);
handleMessageInsertion($pdo);
deleteMessage($pdo);
$messages = fetchMessages($pdo);

// Handling alerts
$alertMessage = '';
if (isset($_GET['truncate'])) {
    $alertMessage = $_GET['truncate'] === 'success' ? '<div class="alert alert-success">Table truncated successfully!</div>' : '<div class="alert alert-danger">Error truncating table!</div>';
}
if (isset($_GET['insert'])) {
    $alertMessage = $_GET['insert'] === 'success' ? '<div class="alert alert-success">Message added successfully!</div>' : '<div class="alert alert-danger">Error adding message!</div>';
}
if (isset($_GET['delete'])) {
    $alertMessage = $_GET['delete'] === 'success' ? '<div class="alert alert-success">Message deleted successfully!</div>' : '<div class="alert alert-danger">Error deleting message!</div>';
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CNV - Project A</title>
    <!-- Load Bootstrap 5.3 CSS from a local copy -->
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <!-- Load custom CSS -->
    <link rel="stylesheet" href="css/site.css">
</head>
<body class="d-flex flex-column">
    <?php include 'partials/navbar.php'; ?>

    <!-- Begin page content -->
    <main class="flex-shrink-0">
        <div class="container mt-5">
            <h1 class="text-center">Message Board</h1>

            <!-- Display alert messages -->
            <?php echo $alertMessage; ?>

            <!-- Display messages table -->
            <?php if (!empty($messages)): ?>
                <table class="table table-dark table-striped">
                    <thead>
                        <tr>
                            <th scope="col">ID</th>
                            <th scope="col">Message</th>
                            <th scope="col">Created At</th>
                            <th scope="col">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="table-group-divider">
                        <?php foreach ($messages as $message): ?>
                            <tr>
                                <th scope="row"><?php echo $message['id']; ?></th>
                                <td><?php echo $message['message']; ?></td>
                                <td><?php echo date('Y-m-d H:i:s', strtotime($message['created_at'])); ?></td>
                                <td>
                                    <form method="POST">
                                        <input type="hidden" name="message_id" value="<?php echo $message['id']; ?>">
                                        <button type="submit" class="btn btn-danger" name="delete" onclick="return confirm('Are you sure you want to delete this message?');">Delete</button>
                                    </form>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            <?php else: ?>
                <p class="text-center">No messages found.</p>
            <?php endif; ?>

            <hr>

            <!-- Display form to insert a new message -->
            <form method="POST">
                <div class="input-group mb-3">
                    <input type="text" class="form-control" id="message" name="message" placeholder="Enter your message" required>
                    <button type="submit" class="btn btn-primary" name="submit">Submit</button>
                </div>
            </form>

            <hr>

            <!-- Display form to truncate table -->
            <form method="POST">
                <button type="submit" class="btn btn-danger" name="truncate" onclick="return confirm('Are you sure you want to truncate the table? This action cannot be undone.');">Truncate Table</button>
            </form>
        </div>
    </main>

    <?php include 'partials/footer.php'; ?>

    <!-- Load Bootstrap 5.3 JS from a local copy -->
    <script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>
