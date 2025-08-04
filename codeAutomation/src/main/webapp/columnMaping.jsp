<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*,java.time.*,java.time.temporal.ChronoUnit"%>
<%@ page language="java" import="jakarta.servlet.*,jakarta.servlet.http.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Column Mapping</title>
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
        
        <!-- <div id="show" class="mt-4 space-y-2"></div> -->
        <div id="columnFields" class="mt-4 space-y-2"></div>
        

        <div id="btn" class="flex items-center mt-2 mb-2">
        <button type="submit" class="text-white bg-green-500 w-full py-2 text-lg rounded hover:bg-green-700"  >Create Model</button>
        </div> </form> </div></div></div>
<!-- <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.jquery.com/ui/1.13.0/jquery-ui.min.js"></script>
<script>
$(function () {
  $("#myTable tbody").sortable();
});
</script> -->
<script>
document.getElementById('table_name').addEventListener('change', function () {
    const selectedTable = this.value;
    const fieldsDiv = document.getElementById('columnFields');
    /* const show = document.getElementById('show'); */
    fieldsDiv.innerHTML = "";

    if (!selectedTable) return;

    fetch("getColumns.jsp?table=" + selectedTable)
        .then(res => res.json())
        .then(columns => {
            if (columns.length === 0) {
                fieldsDiv.innerHTML = "<p class='text-red-500'>No columns found.</p>";
                return;
            }
            /* show.innerHTML = columns[0].name; */
/*             let i = 0 ;
             while(i < columns.length){
            	 const field = document.createElement('div');
                 field.innerHTML = `
                     <label class="block font-semibold text-left">${columns[i].name} (${columns[i].type}):</label>
                     <input name="${columns[i].name}" type="text" class="w-full p-2 border border-gray-300 rounded" />
                 `;
                 fieldsDiv.appendChild(field);
             } */

              /* columns.forEach(col => {
                const field = document.createElement('div');
                field.innerHTML = `
                    <label class="block font-semibold text-left">col.name (col.type):</label>
                    <input name="${col.name}" type="text" class="w-full p-2 border border-gray-300 rounded" />
                `;
                fieldsDiv.appendChild(field);
            }); 
      */
         /* columns.forEach(col => {
                const fieldWrapper = document.createElement('div');
                fieldWrapper.className = "flex items-center mb-2";

                const label = document.createElement('label');
                label.className = "flex-1 font-semibold text-left mb-1 break-normal";
                label.textContent = col.name +'  ('+col.type+')';
                
                
                const inputWrapper = document.createElement('div');
                inputWrapper.className = "flex-auto";
                
                const input = document.createElement('input');
                input.name = col.name;
                input.type = "text";
                input.className = "w-full p-2 border border-gray-300 rounded";
                
                inputWrapper.append(input);
                

                fieldWrapper.appendChild(label);
                fieldWrapper.appendChild(inputWrapper);
                fieldsDiv.appendChild(fieldWrapper);
            }); */
            
            const fieldWrapper = document.createElement('div');
            fieldWrapper.className = "flex items-center mb-2";

            const label = document.createElement('label');
            label.className = "flex-1 font-semibold text-left mb-1";
            label.textContent = 'Mapping Table Name' ;
            
            
            const inputWrapper = document.createElement('div');
            inputWrapper.className = "flex-auto";
            
            const input = document.createElement('input');
            input.name = 'mapping_table_name';
            input.id = 'mapping_table_name';
            input.type = "text";
            input.className = "w-full p-2 border border-gray-300 rounded";
            input.setAttribute('list', 'mappingTable'); 
            
            const datalist = document.createElement('datalist');
            datalist.id = 'mappingTable';
            
            fetch("getMappingColumn.jsp?table=" + selectedTable)
            .then(res => res.json())
            .then(columns => {
                if (columns.length === 0) {
/*                     fieldsDiv.innerHTML = "<p class='text-red-500'>No columns found.</p>"; */
                    return;
                }
                columns.forEach(col => {
            
            const option = document.createElement('option');
            option.value = col.name;

            datalist.appendChild(option);
                });
            }).catch(err => {
                console.log("error");
            });
            
            inputWrapper.append(input);
            

            fieldWrapper.appendChild(label);
            fieldWrapper.appendChild(inputWrapper);
            fieldWrapper.appendChild(datalist);
            fieldsDiv.appendChild(fieldWrapper);
            
            const table = document.createElement('table');
            table.className = "w-full border border-gray-300 text-left text-sm text-gray-700";
            table.id = "myTable";

            // Optional: Add table header
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
            
            
            fieldsDiv.appendChild(table);
            
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
            fieldsDiv.innerHTML = "<p class='text-red-500'>Error loading columns.</p>";
        });
});

document.getElementById('mapping_table_name').addEventListener('input', function () {
	const selectedTable = document.getElementById('table_name').value;
    const selectedMappingTable = this.value;
    const table = document.getElementById('myTable');
    
    table.innerHTML = "";
    
    console.log("Mapping table selected:", selectedMappingTable);
    console.log("Main table selected:", selectedTable);

    /* fieldsDiv.innerHTML = ""; */

    if (!selectedTable) return;
    if (!selectedMappingTable) return; 

    fetch("getMappingColumnValues.jsp?table=" +selectedTable+"&mappingTable="+selectedMappingTable)
        .then(res => res.json())
        .then(columns => {
            if (columns.length === 0) {
                fieldsDiv.innerHTML = "<p class='text-red-500'>No columns found.</p>";
                return;
            }
          
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
                input.value = col.user_defined_name;
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
            fieldsDiv.innerHTML = "<p class='text-red-500'>Error loading columns.</p>";
        });
});


</script>
</body>
</html>