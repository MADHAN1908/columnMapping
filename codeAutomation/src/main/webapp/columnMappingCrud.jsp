<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*,java.time.*,java.time.temporal.ChronoUnit"%>
<%@ page language="java" import="jakarta.servlet.*,jakarta.servlet.http.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Column Mapping Crud</title>
<link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class = "flex justify-center items-center min-h-screen  bg-gray-200">

 
       
        <div class="mt-20 w-full">
        <div class="flex-auto mr-2 text-center">
        <div  class="flex justify-center items-center " >
        <form method="POST" action="columnMapping"  class="bg-gray-100 border-4 border-blue-800 w-1/2 p-5 rounded-md flex flex-col h-auto max-h-[450px] m-5 md:max-w-[375px]">
        <h1 class="text-blue-800 text-center text-3xl mb-4">Column Mapping</h1>
        
        <div class="flex items-center mb-2">
    <label class="flex-1 text-lg mr-2 text-left font-semibold" for="table_name">Table:</label>
    <div class="flex-auto">
        <select name="table_name" id="table_name" class="w-full p-1 border border-gray-300 rounded">
            <option value="">Select Table</option>
            <%
                try {
                    Class.forName("org.postgresql.Driver");
                    String url = "jdbc:postgresql://localhost:5432/perfix_dev";
                    String user = "postgres";
                    String password = ""; 

                    Connection conn = DriverManager.getConnection(url, user, password);

                    if (conn != null) {
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT * FROM information_schema.tables WHERE table_schema = 'public'");

                        boolean hasData = false;
                        while (rs.next()) {
                            hasData = true;
                            String tableName = rs.getString("table_name");
                            out.println("<option value=\"" + tableName + "\">" + tableName + "</option>");
                        }

                        if (!hasData) {
                            out.println("<option>No Tables Found</option>");
                        }

                        conn.close();
                    } else {
                        out.println("<option>Connection Failed</option>");
                    }
                } catch (Exception e) {
                    out.println("<option>Error: " + e.getMessage() + "</option>");
                }
            %>
        </select>
    </div>
</div>
        
        <div id="mappingTable" class="mt-4 space-y-2"></div>
        
        <div id="columnFields" class="mt-4 space-y-2"></div>
        

        <div id="btn" class="flex items-center mt-2 mb-2">
        <button type="submit" class="text-white bg-green-500 w-full py-2 text-lg rounded hover:bg-green-700"  >Create Model</button>
        </div> </form> </div></div></div>

<script>
document.getElementById('table_name').addEventListener('change', function () {
    const selectedTable = this.value;
    const mappingTableColumn = document.getElementById('columnFields');
    const mappingTable = document.getElementById('mappingTable');
    
    mappingTable.innerHTML = " ";
    mappingTableColumn.innerHTML = " ";
    

    if (!selectedTable) return;
    
    const headerRow = document.createElement('div');
    headerRow.className = "flex justify-between items-center mb-4";

    // Create heading
    const heading = document.createElement('h2');
    heading.className = "text-xl font-bold text-gray-800";
    heading.textContent = "Mapping Table";

    // Create Add button
    const addButton = document.createElement('button');
    addButton.type = "button";
    addButton.id = "addButton";
    addButton.className = "bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded";
    addButton.textContent = "New";
    
    addButton.addEventListener("click",() => {
    	MappingTableColumn();
    	mappingTable.innerHTML = "";
    });

    // Append heading and button to the flex row
    headerRow.appendChild(heading);
    headerRow.appendChild(addButton);

    // Append to your container
    mappingTable.appendChild(headerRow);

    fetch("getMappingColumn.jsp?table=" + selectedTable)
        .then(res => res.json())
        .then(columns => {
        	
            if (columns.length === 0) {
            	const errorMessage = document.createElement('p');
            	errorMessage.className = 'text-red-500';
            	errorMessage.textContent = 'No Mapping Tables Found.';
            	mappingTable.appendChild(errorMessage);
                return;
            }
           
            const table = document.createElement('table');
            table.className = "w-full border border-gray-300 text-left text-sm text-gray-700";
            table.id = "myTable";

            // Optional: Add table header
            const thead = document.createElement('thead');
            thead.innerHTML = `
              <tr class="bg-gray-300">
                <th class="p-2 border border-gray-600 text-left">Mapping Table Name</th>
                <th class="p-2 border border-gray-600 text-left">Edit</th>
              </tr>
            `;
            table.appendChild(thead);

            // Create tbody
            const tbody = document.createElement('tbody');
            columns.forEach(col => {
            	const row = document.createElement('tr');
                row.className = "border border-gray-600";
                
                const labelName = document.createElement('td');
                labelName.className = "border border-gray-600 p-2 align-top font-medium";
                labelName.textContent = col.name;
                
                const editButton = document.createElement('button');
                editButton.type = "button";
                editButton.className = "bg-blue-600 hover:bg-blue-700 text-white m-2 px-4 py-2 rounded";
                editButton.textContent = "Edit";
                
                editButton.addEventListener("click",() => {
                	MappingTableColumnUpdate(col.name);
                	mappingTable.innerHTML = "";
                });
                
                row.appendChild(labelName);
                row.appendChild(editButton);

                tbody.appendChild(row);
            });

            table.appendChild(tbody);
            
            
            mappingTable.appendChild(table);         
})
        .catch(err => {
        	const errorMessage = document.createElement('p');
        	errorMessage.className = 'text-red-500';
        	errorMessage.textContent = 'Error loading columns.';
        	mappingTable.appendChild(errorMessage);
        });
});



   function MappingTableColumnUpdate (mappingTable) {
	const selectedTable = document.getElementById('table_name').value;
    const selectedMappingTable = mappingTable;
    const mappingTableColumn = document.getElementById('columnFields');
    
    mappingTableColumn.innerHTML = "";
    
    console.log("Mapping table selected:", selectedMappingTable);
    console.log("Main table selected:", selectedTable);

    

    if (!selectedTable) return;
    if (!selectedMappingTable) return; 

    fetch("getMappingColumnValues.jsp?table=" +selectedTable+"&mappingTable="+selectedMappingTable)
        .then(res => res.json())
        .then(columns => {
        	console.log(1);
            if (columns.length === 0) {
                mappingTableColumn.innerHTML = "<p class='text-red-500'>No columns found.</p>";
                return;
            }
            console.log(columns);
            const fieldWrapper = document.createElement('div');
            fieldWrapper.className = "flex items-center mb-2";

            const label = document.createElement('label');
            label.className = "flex-1 font-semibold text-left mb-1";
            label.textContent = 'Mapping Table Name' ;
            
            
            const inputWrapper = document.createElement('div');
            inputWrapper.className = "flex-auto";
            
            const inputMappingTableName = document.createElement('input');
            inputMappingTableName.name = 'mapping_table_name';
            inputMappingTableName.id = 'mapping_table_name';
            inputMappingTableName.type = "text";
            inputMappingTableName.className = "w-full p-2 border border-gray-300 rounded";
            inputMappingTableName.value = columns[0].mapping_table_name;
            
            inputWrapper.append(inputMappingTableName);
            

            fieldWrapper.appendChild(label);
            fieldWrapper.appendChild(inputWrapper);
            mappingTableColumn.appendChild(fieldWrapper);
            
            const table = document.createElement('table');
            table.className = "w-full border border-gray-300 text-left text-sm text-gray-700";
            table.id = "myTable";
          
            
            const thead = document.createElement('thead');
            thead.innerHTML = `
              <tr class="bg-gray-300">
            	<th class="p-2 border border-gray-600 text-left"></th>
                <th class="p-2 border border-gray-600 text-left">Column Name</th>
                <th class="p-2 border border-gray-600 text-left">Column Type</th>
                <th class="p-2 border border-gray-600 text-left">Length</th>
                <th class="p-2 border border-gray-600 text-left">Input</th>
                <th class="p-2 border border-gray-600 text-left">Visibility</th>
                <th class="p-2 border border-gray-600 text-left">Position</th>
              </tr>
            `;
            table.appendChild(thead);

            // Create tbody
            const tbody = document.createElement('tbody');
            let i =0;
            columns.forEach(col => {
            	console.log(i);
                const row = document.createElement('tr');
                row.className = "border border-gray-600";
                row.setAttribute('draggable', true); // Make row draggable

             // Track the currently dragged row
             row.addEventListener('dragstart', function (e) {
                 e.dataTransfer.setData('text/plain', row.rowIndex);
                 row.classList.add('bg-yellow-100'); // optional highlight
             });

             // Remove highlight
             row.addEventListener('dragend', function () {
                 row.classList.remove('bg-yellow-100');
             });

             // Allow drop
             row.addEventListener('dragover', function (e) {
                 e.preventDefault(); // Necessary to allow drop
             });

             // Handle drop
             row.addEventListener('drop', function (e) {
                 e.preventDefault();
                 const draggedIndex = e.dataTransfer.getData('text/plain');
                 const draggedRow = table.rows[draggedIndex];

                 const targetRow = e.currentTarget;

                 if (draggedRow && draggedRow !== targetRow) {
                     const tbody = table.querySelector('tbody');
                     if (draggedRow.rowIndex < targetRow.rowIndex) {
                         tbody.insertBefore(draggedRow, targetRow.nextSibling);
                     } else {
                         tbody.insertBefore(draggedRow, targetRow);
                     }
                     updateRowPositions();
                 }
             });

                const labelDrag = document.createElement('td');
                labelDrag.className = "border border-gray-600 p-2 align-top cursor-move text-center";
                labelDrag.textContent = "≡";
                
                const labelName = document.createElement('td');
                labelName.className = "border border-gray-600 p-2 align-top font-medium";
                labelName.textContent = col.name;
                
                const labelType = document.createElement('td');
                labelType.className = "border border-gray-600 p-2 align-top font-medium";
                labelType.textContent = col.type;
                
                const labelLength = document.createElement('td');
                labelLength.className = "border border-gray-600 border-gray-600 p-2 align-top font-medium";
                labelLength.textContent = col.length;

                const inputMapName = document.createElement('td');
                inputMapName.className = "border border-gray-600 p-2";
                
                const inputId = document.createElement('input');
                inputId.name = col.name+'_id';
                inputId.type = "hidden";
                inputId.value = col.id ?? '';
                inputId.className = "w-full p-2 bg-transparent rounded";
                inputMapName.appendChild(inputId);

                const input = document.createElement('input');
                input.name = col.name;
                input.type = "text";
                input.value = col.user_defined_name;
                input.className = "w-full p-2 bg-transparent rounded";
                inputMapName.appendChild(input);
                
                const inputCheckBox = document.createElement('td');
                inputCheckBox.className = "border border-gray-600 p-2";

                const inputCheck = document.createElement('input');
                inputCheck.name = col.name+'_visibility';
                inputCheck.type = "checkbox";
                inputCheck.checked = col.visibility == "1" ? true :false ; 
                inputCheck.className = "w-full p-2 bg-transparent rounded";
                
                inputCheckBox.appendChild(inputCheck);
                
                const inputPosition = document.createElement('td');
                inputPosition.className = "border border-gray-600 p-2";

                const position = document.createElement('input');
                position.name = col.name+"_position";
                position.readOnly = true;
                position.type = "number";
                position.className = "w-full p-2 bg-transparent rounded position-cell";
                position.value = col.position;
                inputPosition.appendChild(position);
               

                row.appendChild(labelDrag);
                row.appendChild(labelName);
                row.appendChild(labelType);
                row.appendChild(labelLength);
                row.appendChild(inputMapName);
                row.appendChild(inputCheckBox);
                row.appendChild(inputPosition);
                tbody.appendChild(row);
            });

            table.appendChild(tbody);
            mappingTableColumn.appendChild(table);
            
            
            
            function updateRowPositions() {
                const rows = table.querySelectorAll("tbody tr");
                rows.forEach((row, index) => {
                    const positionCell = row.querySelector(".position-cell");
                    if (positionCell) {
                        positionCell.value = index + 1;
                    }
                });
            }
            
           
           
})
        .catch(err => {
            mappingTableColumn.innerHTML = "<p class='text-red-500'>Error loading columns.</p>";
        });
}; 


  function MappingTableColumn() {
    const selectedTable = document.getElementById('table_name').value;
    const mappingTableColumn = document.getElementById('columnFields');
    mappingTableColumn.innerHTML = "";
    
    console.log("start");
    if (!selectedTable) return;

    fetch("GetColumns?table=" + selectedTable)
        .then(res => res.json())
        .then(columns => {
        	console.log(columns);
            if (columns.length === 0) {
                mappingTableColumn.innerHTML = "<p class='text-red-500'>No columns found.</p>";
                return;
            }
         
            console.log(1);
            const fieldWrapper = document.createElement('div');
            fieldWrapper.className = "flex items-center mb-2";
            console.log(1.1);
            const label = document.createElement('label');
            label.className = "flex-1 font-semibold text-left mb-1";
            label.textContent = 'Mapping Table Name' ;
            
            console.log(1.2);
            const inputWrapper = document.createElement('div');
            inputWrapper.className = "flex-auto";
            console.log(1.3);
            const input = document.createElement('input');
            input.name = 'mapping_table_name';
            input.id = 'mapping_table_name';
            input.type = "text";
            input.className = "w-full p-2 border border-gray-300 rounded";
            console.log(1.5);
            inputWrapper.append(input);
            console.log(1.6);

            fieldWrapper.appendChild(label);
            fieldWrapper.appendChild(inputWrapper);
            mappingTableColumn.appendChild(fieldWrapper);
            console.log(2);
            const table = document.createElement('table');
            table.className = "w-full border border-gray-300 text-left text-sm text-gray-700";
            table.id = "myTable";

           
            const thead = document.createElement('thead');
            thead.innerHTML = `
              <tr class="bg-gray-300">
            	<th class="p-2 border border-gray-600 text-left"></th>
                <th class="p-2 border border-gray-600 text-left">Column Name</th>
                <th class="p-2 border border-gray-600 text-left">Column Type</th>
                <th class="p-2 border border-gray-600 text-left">Length</th>
                <th class="p-2 border border-gray-600 text-left">Input</th>
                <th class="p-2 border border-gray-600 text-left">Visibility</th>
                <th class="p-2 border border-gray-600 text-left">Position</th>
              </tr>
            `;
            table.appendChild(thead);

            // Create tbody
            const tbody = document.createElement('tbody');
            let i =0;
            columns.forEach(col => {
            	console.log(1);
            	console.log(col);
                const row = document.createElement('tr');
                row.className = "border border-gray-600";
                row.setAttribute('draggable', true); // Make row draggable

             // Track the currently dragged row
             row.addEventListener('dragstart', function (e) {
                 e.dataTransfer.setData('text/plain', row.rowIndex);
                 row.classList.add('bg-yellow-100'); // optional highlight
             });

             // Remove highlight
             row.addEventListener('dragend', function () {
                 row.classList.remove('bg-yellow-100');
             });

             // Allow drop
             row.addEventListener('dragover', function (e) {
                 e.preventDefault(); // Necessary to allow drop
             });

             // Handle drop
             row.addEventListener('drop', function (e) {
                 e.preventDefault();
                 const draggedIndex = e.dataTransfer.getData('text/plain');
                 const draggedRow = table.rows[draggedIndex];

                 const targetRow = e.currentTarget;

                 if (draggedRow && draggedRow !== targetRow) {
                     const tbody = table.querySelector('tbody');
                     if (draggedRow.rowIndex < targetRow.rowIndex) {
                         tbody.insertBefore(draggedRow, targetRow.nextSibling);
                     } else {
                         tbody.insertBefore(draggedRow, targetRow);
                     }
                     updateRowPositions();
                 }
             });

                const labelDrag = document.createElement('td');
                labelDrag.className = "border border-gray-600 p-2 align-top cursor-move text-center";
                labelDrag.textContent = "≡";
                
                const labelName = document.createElement('td');
                labelName.className = "border border-gray-600 p-2 align-top font-medium";
                labelName.textContent = col.name;
                
                const labelType = document.createElement('td');
                labelType.className = "border border-gray-600 p-2 align-top font-medium";
                labelType.textContent = col.type;
                
                const labelLength = document.createElement('td');
                labelLength.className = "border border-gray-600 border-gray-600 p-2 align-top font-medium";
                labelLength.textContent = col.length;

                const inputMapName = document.createElement('td');
                inputMapName.className = "border border-gray-600 p-2";

                const input = document.createElement('input');
                input.name = col.name;
                input.type = "text";
                input.className = "w-full p-2 bg-transparent rounded";
                inputMapName.appendChild(input);
                
                const inputCheckBox = document.createElement('td');
                inputCheckBox.className = "border border-gray-600 p-2";

                const inputCheck = document.createElement('input');
                inputCheck.name = col.name+'_visibility';
                inputCheck.type = "checkbox";
                inputCheck.className = "w-full p-2 bg-transparent rounded";
                
                inputCheckBox.appendChild(inputCheck);
                
                const inputPosition = document.createElement('td');
                inputMapName.className = "border border-gray-600 p-2";

                const position = document.createElement('input');
                position.name = col.name+"_position";
                position.readonly = true;
                position.type = "number";
                position.className = "w-full p-2 bg-transparent rounded position-cell";
                position.value = ++i;
                inputPosition.appendChild(position);
                
                /* const labelPosition = document.createElement('td');
                labelPosition.name = col.name+"_position";
                labelPosition.className = "border border-gray-600 border-gray-600 p-2 align-top font-medium position-cell";
                labelPosition.textContent = ++i; */

                row.appendChild(labelDrag);
                row.appendChild(labelName);
                row.appendChild(labelType);
                row.appendChild(labelLength);
                row.appendChild(inputMapName);
                row.appendChild(inputCheckBox);
                row.appendChild(inputPosition);
                tbody.appendChild(row);
            });

            table.appendChild(tbody);
            
            
            mappingTableColumn.appendChild(table);
            
            function updateRowPositions() {
                const rows = table.querySelectorAll("tbody tr");
                rows.forEach((row, index) => {
                    const positionCell = row.querySelector(".position-cell");
                    if (positionCell) {
                        positionCell.value = index + 1;
                    }
                });
            }
            
           
           
})
        .catch(err => {
            mappingTableColumn.innerHTML = "<p class='text-red-500'>Error loading columns.</p>";
        });
};

</script>
</body>
</html>