# 使用方法
```ruby
# Specs repo
source 'https://github.com/18plan/Specs.git'

# 单个使用
pod 'GKit/{ComponentName}', '{version}'

# 多个一起使用
GKitVersion = '{version}'
pod 'GKit/GetPhotos', GKitVersion
pod 'GKit/ImageBrowse', GKitVersion
pod 'GKit/GReportMTA', GKitVersion
pod 'GKit/Privacy', GKitVersion
```
-----
# 更新步骤

**不要将业务相关的代码放入任何一个Component目录中, 只有通用功能才可以放入GKit中**

## 代码更新
- 提交更新，修改GKit.podspec中的版本号
- 如果新增子库则修改第二位版本号，然后将末尾版本号置零
- 如果是修复bug则末尾版本号加1

> 版本语义参考：[语义化版本 2.0.0](http://semver.org/lang/zh-CN/)

## 打tag
```
$git tag 0.x.x
$git push --tags
```
如果要覆盖原有版本则后面加-f

## 更新pod spec
```
$pod repo push 18plan --allow-warnings --use-libraries

# 在使用-f修改tag后，有可能出现再也无法发布成功的情况，这时候可能是因为pod缓存的缘故
# 可以手动清空缓存
$pod cache clean GKit
```
注：如果没有 https://github.com/18plan/Specs 的写权限请让相关人员开通
