var express = require('express')
var app = express()
var moment = require('moment')
var fs = require('fs');
var path = require('path');
var multer = require('multer');
var exec = require('child_process').exec;
var logger = require('log4js').getLogger("index");
var csvjson = require('csvjson')
var mkdirs = function (dirname) {
	//console.log(dirname);  
	if (fs.existsSync(dirname)) {
		return true;
	} else {
		if (mkdirs(path.dirname(dirname))) {
			fs.mkdirSync(dirname);
			return true;
		}
	}
}

// SHOW LIST OF jmxS
app.get('/', function (req, res, next) {
	logger.info("/")
	res.redirect('/1')
})

app.get('/(:id)', function (req, res, next) {
	var start = (parseInt(req.params.id) - 1) * 20;
	req.getConnection(function (error, conn) {
		conn.query("SELECT * FROM jmxs where isactive=1 and jmeterip='127.0.0.1' ORDER BY id ASC limit " + start + ", 20", function (err, rows, fields) {
			//if(err) throw err
			if (err) {
				req.flash('error', err.sqlMessage)
				res.render('index', {
					title: 'List',
					id: parseInt(req.params.id),
					data: ''
				})
			} else {
				// render to views/jmx/list.ejs template file
				res.render('index', {
					title: 'List',
					id: req.params.id,
					data: rows
				})
			}
		})
	})
})

var storage = multer.diskStorage({
	destination: function (req, file, cb) {
		//console.log(req.body.name)
		mkdirs('public/files/' + req.body.name);
		mkdirs('public/files/' + req.body.name + '/data');
		cb(null, 'public/files/' + req.body.name)  //设定文件上传路径
	},
	//给上传文件重命名，获取添加后缀名
	filename: function (req, file, cb) {
		// console.log(file.originalname) //上传文件的名字
		// console.log(file.mimetype)    //上传文件的类型
		// console.log(file.fieldname) // 上传文件的Input的name名
		// console.log(file.encoding)    // 编码方式
		//var fileFormat = (file.originalname).split("."); //采用分割字符串，来获取文件类型
		//console.log(fileFormat)
		var extname = path.extname(file.originalname); //path下自带方法去获取文件类型
		//console.log(extname);
		var filename = "";
		if (extname == ".jmx") {
			filename = req.body.name + extname;
		} else {
			filename = "data/" + file.originalname;
		}
		cb(null, filename); //更改名字
	}
});
var upload = multer({ storage: storage }) //定制化上传参数
// ADD NEW jmx POST ACTION
app.post('/add', upload.array('files'), function (req, res, next) {
	var name = req.body.name;
	let avatarNames = [];
	req.files.map((elem) => {
		avatarNames.push(elem.filename)
	});
	//console.log(avatarNames)
	var data = fs.readFileSync("public/files/" + name + "/" + name + ".jmx", 'utf8');
	var lines = data.split("\n");
	var ip = "";
	var duration = 0;
	var datas = 0, csvdatas = 0, rightdatas = 0;

	lines.forEach(function (line) {
		if (line.search('<stringProp name="HTTPSampler.domain">') != -1 && line.search('<stringProp name="HTTPSampler.domain"></stringProp>') == -1) {
			ip = line.trim().slice(38, -13)
		}
		if (line.search('<stringProp name="ThreadGroup.duration">') != -1) {
			duration = line.trim().slice(40, -13)
		}
		if (line.search('<stringProp name="filename">data/') != -1) {
			datas++
			temp = line.trim().slice(28, -13);
			if (temp != "") {
				avatarNames.forEach(function (filename) {
					if (temp == filename) {
						rightdatas++
					}
				});
			} else {
				rightdatas++
			}
		}
		if (line.search('</CSVDataSet>') != -1) {
			csvdatas++
		}
	});
	if (ip == "" || duration == 0 || csvdatas != rightdatas || csvdatas > datas) {
		status = "wrong"
	} else {
		status = "inactive"
	}
	var createtime = moment(new Date(Date.now())).format('YYYY-MM-DD HH:mm:ss');

	var jmx = {
		name: name,
		file: req.body.filename,
		status: status,
		isactive: 1,
		ip: ip,
		duration: duration / 60,
		createtime: createtime,
		changetime: createtime,
		jmeterip: '127.0.0.1'
	}
	req.getConnection(function (error, conn) {
		conn.query('INSERT INTO jmxs SET ?', jmx, function (err, result) {
			console.log(err)
			//if(err) throw err
			if (err) {
				req.flash('error', err.sqlMessage);
				// redirect to jmxs list pfile
				res.redirect('/');
			} else {
				if (status == "wrong") {
					req.flash('error', 'jmx file is wrong');
				} else {
					req.flash('success', 'Data added successfully!')
				}
				// redirect to jmxs list pfile
				res.redirect('/')
			}
		})
	})

})

// EDIT jmx POST ACTION
app.post('/edit/(:id)', upload.array('files'), function (req, res, next) {
	var name = req.body.name;
	let avatarNames = [];
	req.files.map((elem) => {
		avatarNames.push(elem.filename)
	});
	// console.log(avatarNames)
	var data = fs.readFileSync("public/files/" + name + "/" + name + ".jmx", 'utf8');
	var lines = data.split("\n");
	var ip = "";
	var duration = 0;
	var datas = 0, csvdatas = 0, rightdatas = 0;
	lines.forEach(function (line) {
		if (line.search('<stringProp name="HTTPSampler.domain">') != -1 && line.search('<stringProp name="HTTPSampler.domain"></stringProp>') == -1) {
			ip = line.trim().slice(38, -13)
		}
		if (line.search('<stringProp name="ThreadGroup.duration">') != -1) {
			duration = line.trim().slice(40, -13)
		}
		if (line.search('<stringProp name="filename">data/') != -1) {
			datas++
			temp = line.trim().slice(28, -13);
			console.log(temp)
			if (temp != "") {
				avatarNames.forEach(function (filename) {
					if (temp == filename) {
						rightdatas++
					}
				});
			} else {
				rightdatas++
			}
		}
		if (line.search('</CSVDataSet>') != -1) {
			csvdatas++
		}
	});
	// console.log(csvdatas)
	// console.log(rightdatas)
	// console.log(datas)
	if (ip == "" || duration == 0 || csvdatas != rightdatas || csvdatas > datas) {
		status = "wrong"
	} else {
		status = "inactive"
	}
	var changetime = moment(new Date(Date.now())).format('YYYY-MM-DD HH:mm:ss')
	var jmx = {
		file: req.body.filename,
		changetime: changetime,
		ip: ip,
		duration: duration / 60,
		status: status
	}

	req.getConnection(function (error, conn) {
		conn.query('UPDATE jmxs SET ? WHERE id = ' + req.params.id, jmx, function (err, result) {
			//console.log(err)
			//if(err) throw err
			if (err) {
				req.flash('error', err.sqlMessage)
				// redirect to jmxs list pfile
				res.redirect('/')
			} else {
				req.flash('success', 'Data updated successfully!')
				// redirect to jmxs list pfile
				res.redirect('/')
			}
		})
	})

})

// EDIT performance POST ACTION
app.post('/editchart/(:id)', upload.array('files'), function (req, res, next) {
	var changetime = moment(new Date(Date.now())).format('YYYY-MM-DD HH:mm:ss')
	var jmx = {
		user: req.body.user,
		pw: req.body.pw,
		process: req.body.process,
		pid: req.body.pid,
		changetime: changetime
	}
	cmdStr = "sh add_mem.sh '" + req.body.ip + "' '" + jmx.user + "' '" + jmx.pw + "' '" + jmx.process + "'";
	console.log(cmdStr)
	exec(cmdStr, function (err, stdout, stderr) {
		if (err) {
			console.log(err)
			req.flash('error', err)
			res.redirect('/')
		} else {
			req.getConnection(function (error, conn) {
				conn.query('UPDATE jmxs SET ? WHERE id = ' + req.params.id, jmx, function (err, result) {
					//console.log(err)
					//if(err) throw err
					if (err) {
						req.flash('error', err.sqlMessage)
						// redirect to jmxs list pfile
						res.redirect('/')
					} else {
						req.flash('success', 'Data updated successfully!')
						// redirect to jmxs list pfile
						res.redirect('/')
					}
				})
			})
		}
	})
})

// DELETE jmx
app.delete('/delete/(:ids)', function (req, res, next) {
	var ids = req.params.ids.split(",")
	//console.log(ids)

	req.getConnection(function (error, conn) {
		conn.query('UPDATE jmxs SET isactive=0 WHERE id in (' + ids + ')', function (err, result) {
			//if(err) throw err
			if (err) {
				req.flash('error', err.sqlMessage)
				// redirect to jmxs list pfile
				res.redirect('/')
			} else {
				req.flash('success', 'jmx deleted successfully! id is in (' + ids + ')')
				// redirect to jmxs list pfile
				res.redirect('/')
			}
		})
	})
})

//start test
app.get('/start/(:id)', function (req, res, next) {
	var id = req.params.id;
	req.getConnection(function (error, conn) {
		conn.query('SELECT * FROM jmxs where isactive=1 and id=' + id, function (err, result) {
			//if(err) throw err
			if (err) {
				req.flash('error', err.sqlMessage)
				res.redirect('/')
			} else {
				//console.log(result[0].file)
				var name = result[0].name;
				var dir = moment(new Date(Date.now())).format('YYYYMMDDHHmmss') + "_" + result[0].duration;
				mkdirs("public/files/" + name + "/" + dir)
				cmdStr = "jmeter -n -t public/files/" + name + "/" + name + ".jmx -l public/files/" + name + "/" + dir + "/log.jtl -e -o public/files/" + name + "/" + dir + "/result"
				console.log(cmdStr)
				exec(cmdStr, function (err, stdout, stderr) {
					if (err) {
						//console.log('error:' + stderr);
						var changetime = moment(new Date(Date.now())).format('YYYY-MM-DD HH:mm:ss')
						var jmx = {
							changetime: changetime,
							status: "error"
						}
						req.getConnection(function (error, conn) {
							conn.query('UPDATE jmxs SET ? WHERE id = ' + id, jmx, function (err, result) {
								//if(err) throw err
								if (err) {
									console.log(err)
								} else {
									console.log("success")
								}
							})
						})
					} else {
						console.log(stdout);
						var proStr = "sh get_mem.sh " + result[0].ip + " " + result[0].user + " " + result[0].pw + " " + result[0].process + " " + result[0].duration + " public/files/" + name + "/" + dir + " " + result[0].pid;
						console.log(proStr)
						exec(proStr, function (err, stdout, stderr) {
							if (err) {
								console.log('error:' + stderr);
								var changetime = moment(new Date(Date.now())).format('YYYY-MM-DD HH:mm:ss')
								var jmx = {
									changetime: changetime,
									status: "error"
								}
								req.getConnection(function (error, conn) {
									conn.query('UPDATE jmxs SET ? WHERE id = ' + id, jmx, function (err, result) {
										//if(err) throw err
										if (err) {
											console.log(err)
										} else {
											console.log("success")
										}
									})
								})
							} else {
								console.log('stdout:' + stdout);
								var changetime = moment(new Date(Date.now())).format('YYYY-MM-DD HH:mm:ss')
								var jmx = {
									changetime: changetime,
									status: "inactive"
								}
								req.getConnection(function (error, conn) {
									conn.query('UPDATE jmxs SET ? WHERE id = ' + id, jmx, function (err, result) {
										//if(err) throw err
										if (err) {
											console.log(err)
										} else {
											console.log("success")
										}
									})
								})
							}
						});
					}
				});

				var changetime = moment(new Date(Date.now())).format('YYYY-MM-DD HH:mm:ss')
				var jmx = {
					changetime: changetime,
					status: "active"
				}
				req.getConnection(function (error, conn) {
					conn.query('UPDATE jmxs SET ? WHERE id = ' + id, jmx, function (err, result) {
						//if(err) throw err
						if (err) {
							console.log(err)
						} else {
							console.log("success")
						}
					})
				})
				req.flash('success', 'jmx start successfully! id is ' + id)
				// redirect to jmxs list pfile
				res.redirect('/')

			}
		})
	})
})

// stop test
app.get('/stop/(:id)', function (req, res, next) {
	var id = req.params.id;
	req.getConnection(function (error, conn) {
		conn.query('SELECT * FROM jmxs where isactive=1 and id=' + id, function (err, result) {
			//if(err) throw err
			if (err) {
				req.flash('error', err.sqlMessage)
				res.redirect('/')
			} else {
				var stopStr = "sh stop_all.sh " + result[0].ip + " " + result[0].user + " " + result[0].pw + " " + result[0].process + " " + result[0].duration + " " + result[0].name;
				// fs.readFile('stop_top.sh', 'utf8', function (err, data) {
				// 	if (err) {
				// 		console.log(err);
				// 	}
				// 	//console.log(data);
				// });
				exec(stopStr, function (err, stdout, stderr) {
					if (err) {
						console.log('error:' + stderr);
						var changetime = moment(new Date(Date.now())).format('YYYY-MM-DD HH:mm:ss')
						var jmx = {
							changetime: changetime,
							status: "error"
						}
						req.getConnection(function (error, conn) {
							conn.query('UPDATE jmxs SET ? WHERE id = ' + id, jmx, function (err, result) {
								//if(err) throw err
								if (err) {
									req.flash('error', err.sqlMessage)
									res.redirect('/')
								} else {
									req.flash('error', stderr)
									res.redirect('/')
								}
							})
						})
					} else {
						console.log(stdout);
						var changetime = moment(new Date(Date.now())).format('YYYY-MM-DD HH:mm:ss')
						var jmx = {
							changetime: changetime,
							status: "inactive"
						}
						req.getConnection(function (error, conn) {
							conn.query('UPDATE jmxs SET ? WHERE id = ' + id, jmx, function (err, result) {
								//if(err) throw err
								if (err) {
									req.flash('error', err.sqlMessage)
									res.redirect('/')
								} else {
									req.flash('success', 'jmx stop successfully! id is ' + id)
									res.redirect('/')
								}
							})
						})
					}
				});

			}
		})
	})
})

// VIEW jmx files and test results
app.get('/view/(:id)', function (req, res, next) {
	var id = req.params.id;
	req.getConnection(function (error, conn) {
		conn.query('SELECT * FROM jmxs where isactive=1 and id=' + id, function (err, result) {
			//if(err) throw err
			if (err) {
				req.flash('error', err.sqlMessage)
				res.redirect('/')
			} else {
				//console.log(result[0].file)
				var name = result[0].name;
				res.redirect('/public/files/' + name)
			}
		})
	})
})

//async form verify -uniqname
app.post('/uniqname', function (req, res, next) {
	var name = req.body.name;
	var id = req.body.id;
	console.log(id)
	var num = 0;
	var query = "";
	if (id != undefined) {
		num = 1;
		query = 'select * from jmxs where name="' + name + '" and id=' + id;
	} else {
		query = 'select * from jmxs where name="' + name + '"';
	}
	req.getConnection(function (error, conn) {
		conn.query(query, function (err, result) {
			//if(err) throw err
			if (err || result.length > num) {
				res.send("name must be uniq")
			} else {
				res.json({ 'success': '' })
			}
		})
	})
})

//async form verify -rightpw
app.post('/rightpw', function (req, res, next) {
	var ip = req.body.ip;
	var user = req.body.user;
	var pw = req.body.pw;
	cmdStr = "sshpass -p " + pw + " ssh -o StrictHostKeyChecking=no " + user + "@" + ip + " exit"
	exec(cmdStr, function (err, stdout, stderr) {
		if (err) {
			console.log(err)
			res.send("something is wrong")
		} else {
			res.json({ 'success': '' })
		}
	})
})

//async form verify -rightpro
app.post('/rightpro', function (req, res, next) {
	var ip = req.body.ip;
	var user = req.body.user;
	var pw = req.body.pw;
	var process = req.body.process;
	var rightprostr = "pgrep " + process + ";docker ps|grep " + process;
	cmdStr = 'sshpass -p ' + pw + ' ssh -o StrictHostKeyChecking=no ' + user + '@' + ip + ' "' + rightprostr + '"'
	exec(cmdStr, function (err, stdout, stderr) {
		console.log("stdout")
		console.log(stdout)
		if (stdout) {
			res.json({ 'success': stdout })
		} else {
			console.log(stdout)
			res.send("something is wrong")
		}
	})
})


//async getcsvdata to show echart
app.post('/echart/csv', function (req, res, next) {
	logger.info("/echart/csv")
	var filename = req.body.filename;
	//var data = fs.readFileSync('public/files/iehint/20180731144901/hint_5.csv','utf8');
	var options = {
		delimiter: ',', // optional
		quote: '"'
	};
	var result_old = {}, result_top = {}, result_ps = {};
	console.log(filename)
	try {
		data = fs.readFileSync(filename, 'utf8');
		result_old = csvjson.toColumnArray(data, options);
	} catch (err) {
		// Here you get the error when the file was not found,
		// but you also get any other error
		console.log(err)
	}
	try {
		data_top = fs.readFileSync(filename + '_top', 'utf8');
		result_top = csvjson.toColumnArray(data_top, options);
	} catch (err) {
		// Here you get the error when the file was not found,
		// but you also get any other error
		console.log(err)
	}
	try {
		data_ps = fs.readFileSync(filename + '_ps', 'utf8');
		result_ps = csvjson.toColumnArray(data_ps, options);
	} catch (err) {
		// Here you get the error when the file was not found,
		// but you also get any other error
		console.log(err)
	}
	var result = Object.assign(result_old, result_top, result_ps)
	console.log(result)
	res.json({ 'success': '', 'data': result })
})
module.exports = app
