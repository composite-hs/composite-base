import BuilderSpec (builderSuite)
import RecordSpec (recordSuite)
import THSpec (thSuite)
import Test.Hspec (hspec)

main :: IO ()
main = hspec $ do
  recordSuite
  thSuite
  builderSuite
