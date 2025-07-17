import React, { useState } from 'react';
import { Calendar, Users, BookOpen, Bell, LogIn, UserPlus, Home, Settings } from 'lucide-react';

interface User {
  id: number;
  username: string;
  role: 'admin' | 'lecturer' | 'student';
  email: string;
}

interface Schedule {
  id: number;
  date: string;
  startTime: string;
  endTime: string;
  module: string;
  lecturer: string;
  room: string;
  batch: string;
}

function App() {
  const [currentUser, setCurrentUser] = useState<User | null>(null);
  const [activeTab, setActiveTab] = useState('home');
  const [schedules, setSchedules] = useState<Schedule[]>([
    {
      id: 1,
      date: '2025-01-15',
      startTime: '09:00',
      endTime: '11:00',
      module: 'Database Systems',
      lecturer: 'Dr. Smith',
      room: 'Lab 101',
      batch: 'CS-2023'
    },
    {
      id: 2,
      date: '2025-01-15',
      startTime: '14:00',
      endTime: '16:00',
      module: 'Web Development',
      lecturer: 'Prof. Johnson',
      room: 'Room 205',
      batch: 'CS-2023'
    }
  ]);

  const [loginForm, setLoginForm] = useState({ username: '', password: '' });
  const [registerForm, setRegisterForm] = useState({
    firstName: '',
    lastName: '',
    username: '',
    email: '',
    phone: '',
    role: 'student' as 'admin' | 'lecturer' | 'student',
    department: '',
    password: ''
  });

  // Mock users for demo
  const mockUsers: User[] = [
    { id: 1, username: 'admin', role: 'admin', email: 'admin@acnsms.com' },
    { id: 2, username: 'lecturer1', role: 'lecturer', email: 'lecturer@acnsms.com' },
    { id: 3, username: 'student1', role: 'student', email: 'student@acnsms.com' }
  ];

  const handleLogin = (e: React.FormEvent) => {
    e.preventDefault();
    // Mock login - in real app, this would validate against backend
    const user = mockUsers.find(u => u.username === loginForm.username);
    if (user && loginForm.password === 'password123') {
      setCurrentUser(user);
      setActiveTab('dashboard');
    } else {
      alert('Invalid credentials. Use any username from the demo with password: password123');
    }
  };

  const handleRegister = (e: React.FormEvent) => {
    e.preventDefault();
    // Mock registration
    const newUser: User = {
      id: mockUsers.length + 1,
      username: registerForm.username,
      role: registerForm.role,
      email: registerForm.email
    };
    setCurrentUser(newUser);
    setActiveTab('dashboard');
  };

  const handleLogout = () => {
    setCurrentUser(null);
    setActiveTab('home');
    setLoginForm({ username: '', password: '' });
  };

  const renderNavigation = () => (
    <nav className="bg-indigo-600 text-white p-4">
      <div className="container mx-auto flex justify-between items-center">
        <div className="flex items-center space-x-2">
          <Calendar className="w-8 h-8" />
          <h1 className="text-xl font-bold">ACNSMS</h1>
        </div>
        
        <div className="flex space-x-4">
          {!currentUser ? (
            <>
              <button
                onClick={() => setActiveTab('home')}
                className={`flex items-center space-x-1 px-3 py-2 rounded ${activeTab === 'home' ? 'bg-indigo-700' : 'hover:bg-indigo-500'}`}
              >
                <Home className="w-4 h-4" />
                <span>Home</span>
              </button>
              <button
                onClick={() => setActiveTab('login')}
                className={`flex items-center space-x-1 px-3 py-2 rounded ${activeTab === 'login' ? 'bg-indigo-700' : 'hover:bg-indigo-500'}`}
              >
                <LogIn className="w-4 h-4" />
                <span>Login</span>
              </button>
              <button
                onClick={() => setActiveTab('register')}
                className={`flex items-center space-x-1 px-3 py-2 rounded ${activeTab === 'register' ? 'bg-indigo-700' : 'hover:bg-indigo-500'}`}
              >
                <UserPlus className="w-4 h-4" />
                <span>Register</span>
              </button>
            </>
          ) : (
            <>
              <button
                onClick={() => setActiveTab('dashboard')}
                className={`flex items-center space-x-1 px-3 py-2 rounded ${activeTab === 'dashboard' ? 'bg-indigo-700' : 'hover:bg-indigo-500'}`}
              >
                <Settings className="w-4 h-4" />
                <span>Dashboard</span>
              </button>
              <button
                onClick={() => setActiveTab('schedules')}
                className={`flex items-center space-x-1 px-3 py-2 rounded ${activeTab === 'schedules' ? 'bg-indigo-700' : 'hover:bg-indigo-500'}`}
              >
                <Calendar className="w-4 h-4" />
                <span>Schedules</span>
              </button>
              <button
                onClick={handleLogout}
                className="flex items-center space-x-1 px-3 py-2 rounded hover:bg-indigo-500"
              >
                <LogIn className="w-4 h-4" />
                <span>Logout</span>
              </button>
              <span className="px-3 py-2 bg-indigo-700 rounded">
                {currentUser.username} ({currentUser.role})
              </span>
            </>
          )}
        </div>
      </div>
    </nav>
  );

  const renderHome = () => (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
      <div className="container mx-auto px-4 py-16">
        <div className="text-center mb-16">
          <h1 className="text-5xl font-bold text-gray-800 mb-6">
            Automated Campus Notification and Schedule Management System
          </h1>
          <p className="text-xl text-gray-600 mb-8 max-w-3xl mx-auto">
            Streamline your academic scheduling with integrated Google Calendar, 
            automated notifications, and role-based access control.
          </p>
          <div className="flex justify-center space-x-4">
            <button
              onClick={() => setActiveTab('login')}
              className="bg-indigo-600 text-white px-8 py-3 rounded-lg hover:bg-indigo-700 transition-colors"
            >
              Get Started
            </button>
            <button
              onClick={() => setActiveTab('register')}
              className="border border-indigo-600 text-indigo-600 px-8 py-3 rounded-lg hover:bg-indigo-50 transition-colors"
            >
              Register Now
            </button>
          </div>
        </div>

        <div className="grid md:grid-cols-3 gap-8 mb-16">
          <div className="bg-white p-8 rounded-lg shadow-lg text-center">
            <Calendar className="w-16 h-16 text-indigo-600 mx-auto mb-4" />
            <h3 className="text-xl font-semibold mb-4">Smart Scheduling</h3>
            <p className="text-gray-600">
              Integrate with Google Calendar for seamless schedule management and automatic conflict detection.
            </p>
          </div>
          
          <div className="bg-white p-8 rounded-lg shadow-lg text-center">
            <Bell className="w-16 h-16 text-indigo-600 mx-auto mb-4" />
            <h3 className="text-xl font-semibold mb-4">Instant Notifications</h3>
            <p className="text-gray-600">
              Automated email and SMS notifications for schedule changes, new lectures, and important updates.
            </p>
          </div>
          
          <div className="bg-white p-8 rounded-lg shadow-lg text-center">
            <Users className="w-16 h-16 text-indigo-600 mx-auto mb-4" />
            <h3 className="text-xl font-semibold mb-4">Role-Based Access</h3>
            <p className="text-gray-600">
              Different access levels for administrators, lecturers, and students with appropriate permissions.
            </p>
          </div>
        </div>

        <div className="bg-white rounded-lg shadow-lg p-8">
          <h2 className="text-3xl font-bold text-center mb-8">System Features</h2>
          <div className="grid md:grid-cols-2 gap-8">
            <div>
              <h3 className="text-xl font-semibold mb-4 flex items-center">
                <BookOpen className="w-6 h-6 mr-2 text-indigo-600" />
                For Administrators & Lecturers
              </h3>
              <ul className="space-y-2 text-gray-600">
                <li>• Create and manage lecture schedules</li>
                <li>• Reschedule classes with automatic notifications</li>
                <li>• Assign rooms and manage resources</li>
                <li>• Track attendance and generate reports</li>
                <li>• Integration with Google Calendar</li>
              </ul>
            </div>
            <div>
              <h3 className="text-xl font-semibold mb-4 flex items-center">
                <Users className="w-6 h-6 mr-2 text-indigo-600" />
                For Students
              </h3>
              <ul className="space-y-2 text-gray-600">
                <li>• View personal class schedules</li>
                <li>• Receive instant notifications for changes</li>
                <li>• Access room and lecturer information</li>
                <li>• Export schedules to personal calendars</li>
                <li>• Mobile-friendly interface</li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
  );

  const renderLogin = () => (
    <div className="min-h-screen bg-gray-50 flex items-center justify-center">
      <div className="bg-white p-8 rounded-lg shadow-lg w-full max-w-md">
        <div className="text-center mb-8">
          <Calendar className="w-12 h-12 text-indigo-600 mx-auto mb-4" />
          <h2 className="text-2xl font-bold text-gray-800">Login to ACNSMS</h2>
        </div>
        
        <form onSubmit={handleLogin} className="space-y-6">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Username
            </label>
            <input
              type="text"
              value={loginForm.username}
              onChange={(e) => setLoginForm({...loginForm, username: e.target.value})}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
              required
            />
          </div>
          
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Password
            </label>
            <input
              type="password"
              value={loginForm.password}
              onChange={(e) => setLoginForm({...loginForm, password: e.target.value})}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
              required
            />
          </div>
          
          <button
            type="submit"
            className="w-full bg-indigo-600 text-white py-2 px-4 rounded-md hover:bg-indigo-700 transition-colors"
          >
            Login
          </button>
        </form>
        
        <div className="mt-6 p-4 bg-blue-50 rounded-md">
          <p className="text-sm text-blue-800 font-medium mb-2">Demo Credentials:</p>
          <p className="text-xs text-blue-600">
            Username: admin, lecturer1, or student1<br />
            Password: password123
          </p>
        </div>
        
        <p className="text-center mt-6 text-sm text-gray-600">
          Don't have an account?{' '}
          <button
            onClick={() => setActiveTab('register')}
            className="text-indigo-600 hover:text-indigo-500"
          >
            Register here
          </button>
        </p>
      </div>
    </div>
  );

  const renderRegister = () => (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="container mx-auto px-4">
        <div className="bg-white p-8 rounded-lg shadow-lg max-w-2xl mx-auto">
          <div className="text-center mb-8">
            <Calendar className="w-12 h-12 text-indigo-600 mx-auto mb-4" />
            <h2 className="text-2xl font-bold text-gray-800">Register for ACNSMS</h2>
          </div>
          
          <form onSubmit={handleRegister} className="space-y-6">
            <div className="grid md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  First Name
                </label>
                <input
                  type="text"
                  value={registerForm.firstName}
                  onChange={(e) => setRegisterForm({...registerForm, firstName: e.target.value})}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                  required
                />
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Last Name
                </label>
                <input
                  type="text"
                  value={registerForm.lastName}
                  onChange={(e) => setRegisterForm({...registerForm, lastName: e.target.value})}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                  required
                />
              </div>
            </div>
            
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Username
              </label>
              <input
                type="text"
                value={registerForm.username}
                onChange={(e) => setRegisterForm({...registerForm, username: e.target.value})}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                required
              />
            </div>
            
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Email
              </label>
              <input
                type="email"
                value={registerForm.email}
                onChange={(e) => setRegisterForm({...registerForm, email: e.target.value})}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                required
              />
            </div>
            
            <div className="grid md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Phone
                </label>
                <input
                  type="tel"
                  value={registerForm.phone}
                  onChange={(e) => setRegisterForm({...registerForm, phone: e.target.value})}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                  required
                />
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Role
                </label>
                <select
                  value={registerForm.role}
                  onChange={(e) => setRegisterForm({...registerForm, role: e.target.value as 'admin' | 'lecturer' | 'student'})}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                  required
                >
                  <option value="student">Student</option>
                  <option value="lecturer">Lecturer</option>
                  <option value="admin">Administrator</option>
                </select>
              </div>
            </div>
            
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Department
              </label>
              <input
                type="text"
                value={registerForm.department}
                onChange={(e) => setRegisterForm({...registerForm, department: e.target.value})}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                required
              />
            </div>
            
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Password
              </label>
              <input
                type="password"
                value={registerForm.password}
                onChange={(e) => setRegisterForm({...registerForm, password: e.target.value})}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                required
              />
            </div>
            
            <button
              type="submit"
              className="w-full bg-indigo-600 text-white py-2 px-4 rounded-md hover:bg-indigo-700 transition-colors"
            >
              Register
            </button>
          </form>
          
          <p className="text-center mt-6 text-sm text-gray-600">
            Already have an account?{' '}
            <button
              onClick={() => setActiveTab('login')}
              className="text-indigo-600 hover:text-indigo-500"
            >
              Login here
            </button>
          </p>
        </div>
      </div>
    </div>
  );

  const renderDashboard = () => {
    if (!currentUser) return null;

    return (
      <div className="min-h-screen bg-gray-50 py-8">
        <div className="container mx-auto px-4">
          <div className="mb-8">
            <h1 className="text-3xl font-bold text-gray-800 mb-2">
              Welcome, {currentUser.username}
            </h1>
            <p className="text-gray-600">
              {currentUser.role === 'admin' && 'System Administrator Dashboard'}
              {currentUser.role === 'lecturer' && 'Lecturer Dashboard'}
              {currentUser.role === 'student' && 'Student Dashboard'}
            </p>
          </div>

          <div className="grid md:grid-cols-3 gap-6 mb-8">
            <div className="bg-white p-6 rounded-lg shadow-lg">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-gray-600">Total Schedules</p>
                  <p className="text-2xl font-bold text-gray-900">{schedules.length}</p>
                </div>
                <Calendar className="w-8 h-8 text-indigo-600" />
              </div>
            </div>

            <div className="bg-white p-6 rounded-lg shadow-lg">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-gray-600">Today's Classes</p>
                  <p className="text-2xl font-bold text-gray-900">3</p>
                </div>
                <BookOpen className="w-8 h-8 text-green-600" />
              </div>
            </div>

            <div className="bg-white p-6 rounded-lg shadow-lg">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-gray-600">Notifications</p>
                  <p className="text-2xl font-bold text-gray-900">5</p>
                </div>
                <Bell className="w-8 h-8 text-yellow-600" />
              </div>
            </div>
          </div>

          {currentUser.role !== 'student' && (
            <div className="bg-white p-6 rounded-lg shadow-lg mb-8">
              <h2 className="text-xl font-semibold mb-4">Quick Actions</h2>
              <div className="grid md:grid-cols-2 gap-4">
                <button className="bg-indigo-600 text-white p-4 rounded-lg hover:bg-indigo-700 transition-colors">
                  Schedule New Lecture
                </button>
                <button className="bg-green-600 text-white p-4 rounded-lg hover:bg-green-700 transition-colors">
                  Send Notification
                </button>
              </div>
            </div>
          )}

          <div className="bg-white p-6 rounded-lg shadow-lg">
            <h2 className="text-xl font-semibold mb-4">Recent Activity</h2>
            <div className="space-y-4">
              <div className="flex items-center space-x-4 p-4 bg-gray-50 rounded-lg">
                <Calendar className="w-6 h-6 text-indigo-600" />
                <div>
                  <p className="font-medium">Database Systems lecture scheduled</p>
                  <p className="text-sm text-gray-600">Today at 9:00 AM - Lab 101</p>
                </div>
              </div>
              <div className="flex items-center space-x-4 p-4 bg-gray-50 rounded-lg">
                <Bell className="w-6 h-6 text-yellow-600" />
                <div>
                  <p className="font-medium">Notification sent to CS-2023 batch</p>
                  <p className="text-sm text-gray-600">Schedule change for Web Development</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  };

  const renderSchedules = () => (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="container mx-auto px-4">
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-800 mb-2">Class Schedules</h1>
          <p className="text-gray-600">View and manage lecture schedules</p>
        </div>

        {currentUser?.role !== 'student' && (
          <div className="bg-white p-6 rounded-lg shadow-lg mb-8">
            <h2 className="text-xl font-semibold mb-4">Add New Schedule</h2>
            <div className="grid md:grid-cols-3 gap-4">
              <input
                type="date"
                className="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
              />
              <input
                type="time"
                className="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
              />
              <input
                type="text"
                placeholder="Module"
                className="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
              />
            </div>
            <div className="grid md:grid-cols-3 gap-4 mt-4">
              <input
                type="text"
                placeholder="Lecturer"
                className="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
              />
              <input
                type="text"
                placeholder="Room"
                className="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
              />
              <input
                type="text"
                placeholder="Batch"
                className="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
              />
            </div>
            <button className="mt-4 bg-indigo-600 text-white px-6 py-2 rounded-md hover:bg-indigo-700 transition-colors">
              Add Schedule
            </button>
          </div>
        )}

        <div className="bg-white rounded-lg shadow-lg overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Date
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Time
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Module
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Lecturer
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Room
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Batch
                  </th>
                  {currentUser?.role !== 'student' && (
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Actions
                    </th>
                  )}
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {schedules.map((schedule) => (
                  <tr key={schedule.id} className="hover:bg-gray-50">
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                      {schedule.date}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                      {schedule.startTime} - {schedule.endTime}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                      {schedule.module}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                      {schedule.lecturer}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                      {schedule.room}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                      {schedule.batch}
                    </td>
                    {currentUser?.role !== 'student' && (
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                        <button className="text-indigo-600 hover:text-indigo-900 mr-4">
                          Edit
                        </button>
                        <button className="text-red-600 hover:text-red-900">
                          Reschedule
                        </button>
                      </td>
                    )}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );

  return (
    <div className="min-h-screen bg-gray-100">
      {renderNavigation()}
      
      {activeTab === 'home' && renderHome()}
      {activeTab === 'login' && renderLogin()}
      {activeTab === 'register' && renderRegister()}
      {activeTab === 'dashboard' && renderDashboard()}
      {activeTab === 'schedules' && renderSchedules()}
    </div>
  );
}

export default App;