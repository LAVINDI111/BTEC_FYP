/**
 * ACNSMS Main JavaScript File
 * Contains all client-side functionality for the application
 */

// Global variables
let currentUser = null;
let schedules = [];
let currentView = 'dashboard';

/**
 * Document ready function
 */
$(document).ready(function() {
    initializeApp();
    setupEventListeners();
    loadUserData();
});

/**
 * Initialize the application
 */
function initializeApp() {
    console.log('ACNSMS Application Initialized');
    
    // Initialize tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
    
    // Initialize popovers
    var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
    var popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
        return new bootstrap.Popover(popoverTriggerEl);
    });
    
    // Add fade-in animation to main content
    $('main').addClass('fade-in');
}

/**
 * Setup event listeners
 */
function setupEventListeners() {
    // Navigation click handlers
    $('.nav-link').on('click', function(e) {
        const href = $(this).attr('href');
        if (href === '#') {
            e.preventDefault();
        }
    });
    
    // Form validation
    $('form').on('submit', function(e) {
        if (!validateForm(this)) {
            e.preventDefault();
        }
    });
    
    // Auto-hide alerts after 5 seconds
    setTimeout(function() {
        $('.alert').fadeOut('slow');
    }, 5000);
}

/**
 * Load user data from server
 */
function loadUserData() {
    // This would typically make an AJAX call to get user data
    // For now, we'll use placeholder data
    currentUser = {
        id: 1,
        name: 'Current User',
        role: 'student'
    };
}

/**
 * Show schedule creation modal
 */
function showScheduleModal() {
    const modalHtml = `
        <div class="modal fade" id="scheduleModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-plus me-2"></i>Add New Schedule
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form id="scheduleForm">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="subject" class="form-label">Subject/Module</label>
                                    <input type="text" class="form-control" id="subject" name="subject" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="lecturer" class="form-label">Lecturer</label>
                                    <select class="form-select" id="lecturer" name="lecturer" required>
                                        <option value="">Select Lecturer</option>
                                        <!-- Options will be populated dynamically -->
                                    </select>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label for="date" class="form-label">Date</label>
                                    <input type="date" class="form-control" id="date" name="date" required>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="startTime" class="form-label">Start Time</label>
                                    <input type="time" class="form-control" id="startTime" name="start_time" required>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="endTime" class="form-label">End Time</label>
                                    <input type="time" class="form-control" id="endTime" name="end_time" required>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="room" class="form-label">Room/Lab</label>
                                    <select class="form-select" id="room" name="room_id" required>
                                        <option value="">Select Room</option>
                                        <!-- Options will be populated dynamically -->
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="program" class="form-label">Program/Batch</label>
                                    <select class="form-select" id="program" name="program_id" required>
                                        <option value="">Select Program</option>
                                        <!-- Options will be populated dynamically -->
                                    </select>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="module" class="form-label">Module</label>
                                <select class="form-select" id="module" name="module_id" required>
                                    <option value="">Select Module</option>
                                    <!-- Options will be populated dynamically -->
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label for="notes" class="form-label">Additional Notes</label>
                                <textarea class="form-control" id="notes" name="notes" rows="3"></textarea>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-2"></i>Cancel
                        </button>
                        <button type="button" class="btn btn-primary" onclick="saveSchedule()">
                            <i class="fas fa-save me-2"></i>Save Schedule
                        </button>
                    </div>
                </div>
            </div>
        </div>
    `;
    
    // Remove existing modal if any
    $('#scheduleModal').remove();
    
    // Add modal to body and show
    $('body').append(modalHtml);
    $('#scheduleModal').modal('show');
    
    // Load dropdown data
    loadDropdownData();
}

/**
 * Load data for dropdown menus
 */
function loadDropdownData() {
    // This would typically make AJAX calls to get data from server
    // For now, we'll use placeholder data
    
    // Load lecturers
    const lecturers = [
        { id: 1, name: 'Dr. Sakunika Perera' },
        { id: 2, name: 'Prof. John Gunawardhana' },
        { id: 3, name: 'Ms. Chathuni De Silva ' },
        { id: 4, name: 'Mr. Indunil Bandara' },
        { id: 5, name: 'Prof. Chanaka Thilakarathne' },
        { id: 6, name: 'Mr. Prasanna Jayawarna ' },

    ];
    
    const lecturerSelect = $('#lecturer');
    lecturers.forEach(lecturer => {
        lecturerSelect.append(`<option value="${lecturer.id}">${lecturer.name}</option>`);
    });
    
    // Load rooms
    const rooms = [
        { id: 1, name: 'LR1' },
        { id: 2, name: 'LR2' },
        { id: 3, name: 'LR3' },
        { id: 4, name: 'LR4' },
        { id: 5, name: 'LR5' },
        { id: 6, name: 'LR6' },
        { id: 7, name: 'Com Lab 1' },
        { id: 8, name: 'Com Lab 2' },
        { id: 9, name: 'Com Lab 3' },
        { id: 10, name: 'DSM lab' },
        { id: 11, name: 'DC lab' },
        { id: 12, name: 'CSP lab' },
        { id: 13, name: "E'tronic lab" }
    ];
    
    const roomSelect = $('#room');
    rooms.forEach(room => {
        roomSelect.append(`<option value="${room.id}">${room.name}</option>`);
    });
    
    // Load programs
    const programs = [
        { id: 1, name: 'HND in Computer Science' },
        { id: 2, name: 'BTEC HND in Computing' },
        { id: 3, name: 'HND in Software Engineering' },
        { id: 4, name: 'BSc in EEE' },
        { id: 5, name: 'BSc in AI' },
        { id: 6, name: 'Certificate in Computer Science' }

    ];
    
    const programSelect = $('#program');
    programs.forEach(program => {
        programSelect.append(`<option value="${program.id}">${program.name}</option>`);
    });
    
    // Load modules
    const modules = [
        { id: 1, name: 'Programming Fundamentals' },
        { id: 2, name: 'Database Systems' },
        { id: 3, name: 'Web Development' },
        { id: 4, name: 'Software Engineering Basics' },
        { id: 5, name: 'Introduction to AI' },
        { id: 6, name: 'IOT' }
    ];
    
    const moduleSelect = $('#module');
    modules.forEach(module => {
        moduleSelect.append(`<option value="${module.id}">${module.name}</option>`);
    });
}

/**
 * Save schedule to database and Google Calendar
 */
function saveSchedule() {
    const form = document.getElementById('scheduleForm');
    
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }
    
    const formData = new FormData(form);
    const scheduleData = Object.fromEntries(formData);
    
    // Show loading spinner
    showLoading('Saving schedule...');
    
    // Make AJAX call to save schedule
    $.ajax({
        url: '/api/schedules',
        method: 'POST',
        data: JSON.stringify(scheduleData),
        contentType: 'application/json',
        success: function(response) {
            hideLoading();
            showNotification('Schedule saved successfully!', 'success');
            $('#scheduleModal').modal('hide');
            refreshScheduleTable();
            //location.reload();//----------------------
        },
        error: function(xhr, status, error) {
            hideLoading();
            showNotification('Error saving schedule: ' + error, 'error');
        }
    });
}

/**
 * Show schedule table
 */
function showScheduleTable() {
    currentView = 'table';
    
    const tableHtml = `
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">
                    <i class="fas fa-table me-2"></i>Schedule Overview
                </h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-hover" id="scheduleTable">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Subject</th>
                                <th>Lecturer</th>
                                <th>Room</th>
                                <th>Program</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="scheduleTableBody">
                            <!-- Data will be populated here -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    `;
    
    // Replace main content
    $('main .container').html(tableHtml);
    
    // Load schedule data
    loadScheduleData();
}

/**
 * Load schedule data for table
 */
function loadScheduleData() {
    // This would typically make an AJAX call
    // For now, we'll use placeholder data
    
    const sampleSchedules = [
        {
            id: 1,
            date: '2025-01-15',
            startTime: '09:00',
            endTime: '11:00',
            subject: 'Programming Fundamentals',
            lecturer: 'Dr. Sakunika Perera',
            room: 'Com Lab 1',
            program: 'BTEC HND Computing',
            status: 'Scheduled'
        },
        {
            id: 2,
            date: '2025-01-16',
            startTime: '14:00',
            endTime: '16:00',
            subject: 'Database Systems',
            lecturer: 'Prof. John Smith',
            room: 'LR2',
            program: 'CAIT Program',
            status: 'Scheduled'
        }
    ];
    
    const tbody = $('#scheduleTableBody');
    tbody.empty();
    
    sampleSchedules.forEach(schedule => {
        const statusClass = getStatusClass(schedule.status);
        const actionButtons = getCurrentUserRole() === 'student' ? 
            '<span class="text-muted">View Only</span>' :
            `<button class="btn btn-sm btn-warning me-1" onclick="rescheduleClass(${schedule.id})">
                <i class="fas fa-edit"></i> Reschedule
             </button>`;
        
        const row = `
            <tr>
                <td>${formatDate(schedule.date)}</td>
                <td>${schedule.startTime} - ${schedule.endTime}</td>
                <td>${schedule.subject}</td>
                <td>${schedule.lecturer}</td>
                <td>${schedule.room}</td>
                <td>${schedule.program}</td>
                <td><span class="status-badge ${statusClass}">${schedule.status}</span></td>
                <td>${actionButtons}</td>
            </tr>
        `;
        
        tbody.append(row);
    });
}

/**
 * Show calendar view
 */
function showCalendarView() {
    currentView = 'calendar';
    
    const calendarHtml = `
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">
                    <i class="fas fa-calendar me-2"></i>Calendar View
                </h5>
            </div>
            <div class="card-body">
                <div class="row mb-3">
                    <div class="col-md-6">
                        <button class="btn btn-primary" onclick="openGoogleCalendar()">
                            <i class="fab fa-google me-2"></i>Open Google Calendar
                        </button>
                    </div>
                    <div class="col-md-6 text-end">
                        <button class="btn btn-outline-primary" onclick="syncWithGoogleCalendar()">
                            <i class="fas fa-sync me-2"></i>Sync with Google Calendar
                        </button>
                    </div>
                </div>
                
                <div id="calendarContainer">
                    <!-- Calendar will be embedded here -->
                    <div class="text-center p-5">
                        <i class="fas fa-calendar-alt fa-3x text-muted mb-3"></i>
                        <h5>Google Calendar Integration</h5>
                        <p class="text-muted">
                            Click "Open Google Calendar" to view and manage schedules in Google Calendar.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    `;
    
    // Replace main content
    $('main .container').html(calendarHtml);
}

/**
 * Open Google Calendar in new tab
 */
function openGoogleCalendar() {
    const calendarUrl = 'https://calendar.google.com/calendar/u/0/r/day/2025/6/15?pli=1';
    window.open(calendarUrl, '_blank');
}

/**
 * Sync with Google Calendar
 */
function syncWithGoogleCalendar() {
    showLoading('Syncing with Google Calendar...');
    
    // Make AJAX call to sync
    $.ajax({
        url: '/api/calendar/sync',
        method: 'POST',
        success: function(response) {
            hideLoading();
            showNotification('Calendar synced successfully!', 'success');
        },
        error: function(xhr, status, error) {
            hideLoading();
            showNotification('Error syncing calendar: ' + error, 'error');
        }
    });
}

/**
 * Reschedule a class
 */
function rescheduleClass(scheduleId) {
    // This would show a reschedule modal
    showNotification('Reschedule functionality will be implemented', 'info');
}

/**
 * Utility Functions
 */

/**
 * Get status CSS class
 */
function getStatusClass(status) {
    switch(status.toLowerCase()) {
        case 'scheduled': return 'status-scheduled';
        case 'completed': return 'status-completed';
        case 'cancelled': return 'status-cancelled';
        default: return 'status-scheduled';
    }
}

/**
 * Format date for display
 */
function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', {
        weekday: 'short',
        year: 'numeric',
        month: 'short',
        day: 'numeric'
    });
}

/**
 * Get current user role (placeholder)
 */
function getCurrentUserRole() {
    // This would get the actual user role from session/server
    return 'lecturer'; // placeholder
}

/**
 * Show loading spinner
 */
function showLoading(message = 'Loading...') {
    const loadingHtml = `
        <div id="loadingOverlay" class="position-fixed top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center" style="background: rgba(0,0,0,0.5); z-index: 9999;">
            <div class="bg-white p-4 rounded text-center">
                <div class="spinner mb-3"></div>
                <p class="mb-0">${message}</p>
            </div>
        </div>
    `;
    
    $('body').append(loadingHtml);
}

/**
 * Hide loading spinner
 */
function hideLoading() {
    $('#loadingOverlay').remove();
}

/**
 * Show notification toast
 */
function showNotification(message, type = 'info') {
    const alertClass = type === 'error' ? 'danger' : type;
    const icon = getNotificationIcon(type);
    
    const toastHtml = `
        <div class="toast align-items-center text-white bg-${alertClass} border-0 notification-toast" role="alert">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="${icon} me-2"></i>${message}
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
    `;
    
    const toastElement = $(toastHtml);
    $('body').append(toastElement);
    
    const toast = new bootstrap.Toast(toastElement[0]);
    toast.show();
    
    // Remove toast element after it's hidden
    toastElement.on('hidden.bs.toast', function() {
        $(this).remove();
    });
}

/**
 * Get notification icon based on type
 */
function getNotificationIcon(type) {
    switch(type) {
        case 'success': return 'fas fa-check-circle';
        case 'error': return 'fas fa-exclamation-circle';
        case 'warning': return 'fas fa-exclamation-triangle';
        case 'info': return 'fas fa-info-circle';
        default: return 'fas fa-info-circle';
    }
}

/**
 * Validate form
 */
function validateForm(form) {
    // Basic form validation
    const requiredFields = form.querySelectorAll('[required]');
    let isValid = true;
    
    requiredFields.forEach(field => {
        if (!field.value.trim()) {
            field.classList.add('is-invalid');
            isValid = false;
        } else {
            field.classList.remove('is-invalid');
        }
    });
    
    return isValid;
}

/**
 * Refresh schedule table
 */
function refreshScheduleTable() {
    if (currentView === 'table') {
        loadScheduleData();
    }
}

/**
 * Initialize dashboard based on user role
 */
function initializeDashboard() {
    const userRole = getCurrentUserRole();
    
    switch(userRole) {
        case 'admin':
            loadAdminDashboard();
            break;
        case 'lecturer':
            loadLecturerDashboard();
            break;
        case 'student':
            loadStudentDashboard();
            break;
        default:
            console.error('Unknown user role:', userRole);
    }
}

/**
 * Load admin dashboard
 */
function loadAdminDashboard() {
    // Admin-specific dashboard functionality
    console.log('Loading admin dashboard');
}

/**
 * Load lecturer dashboard
 */
function loadLecturerDashboard() {
    // Lecturer-specific dashboard functionality
    console.log('Loading lecturer dashboard');
}

/**
 * Load student dashboard
 */
function loadStudentDashboard() {
    // Student-specific dashboard functionality
    console.log('Loading student dashboard');
}