import Foundation

func writeBin(filename: String = "balance.swift.bin") {
    let queryCellNode = buildQueryCell()
    let executionNode = buildExecutionNode(queryCellNode)
    let root = buildRoot("balance", executionNode)

    let file = getDocumentsDirectory().appendingPathComponent(filename)
    do {
        try root.serializedData().write(to: file)
        print("Wrote \(file)")
    } catch {
        print(error)
    }
}

func getDocumentsDirectory() -> URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}
